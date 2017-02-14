//
//  netdb_yi.cpp
//  heibaiyu
//
//  Created by jiwei.wang on 2/9/17.
//  Copyright © 2017 yijian. All rights reserved.
//

#include "netdb_yi.hpp"
#include "buffer_yi_util.hpp"

static const std::string netdb_success_ = "success";

netdb_yi::netdb_yi(const std::string & certpath, const std::string & dbpath, const std::string & phoneModel, const std::string & phoneUDID, const std::string & osVersion, const std::string & appVersion)
:model_(phoneModel), udid_(phoneUDID), os_version_(osVersion), app_version_(appVersion), certpath_(certpath) {
  YILOG_TRACE ("func: {}", __func__);
  isOpenNet_.store(false);
  dbyi_ = new leveldb_yi(dbpath);
  auto device = chat::Device();
  device.set_os(chat::Device_OperatingSystem::Device_OperatingSystem_iOS);
  device.set_devicemodel(model_);
  device.set_uuid(udid_);
  dbyi_->putCurrentDevice(device);
}

netdb_yi::~netdb_yi() {
  YILOG_TRACE ("func: {}", __func__);
  if (isOpenNet_.load()) {
    clear_client();
  }
  delete dbyi_;
}

void netdb_yi::openNet(Client_CB client_callback) {
  YILOG_TRACE ("func: {}", __func__);
  if (isOpenNet_.load()) {
    return;
  }
  netyi_ = new netyi(certpath_);
  client_callback_ = client_callback;
  auto ping = chat::Ping();
  ping.set_msg("ping");
  netyi_->setNetIsReachable(true);
  netyi_->net_connect(yijian::buffer::Buffer(ping), [this](const int error_no, const std::string & error_msg) {
    if (0 == error_no) {
      isOpenNet_.store(true);
      try {
        auto user = dbyi_->getCurrentUser();
        this->connect(user.id(), [this](const int err_no, const std::string & err_msg){
          client_callback_(err_no, err_msg);
        });
      } catch (...) {
        client_callback_(error_no, std::forward<const std::string>(error_msg));
      }
    }else{
      client_callback_(error_no, std::forward<const std::string>(error_msg));
    }
  });
}

void netdb_yi::netIsReachable(bool isreachable) {
  client_setNet_isConnect(isreachable);
}

void netdb_yi::closeNet() {
  YILOG_TRACE ("func: {}", __func__);
  isOpenNet_.store(false);
  clear_client();
}

leveldb_yi * netdb_yi::db() {
  YILOG_TRACE ("func: {}", __func__);
  return dbyi_;
}

/*
 * user
 */
void netdb_yi::registCheck(const std::string & phoneno, const std::string & countrycode, CB_Func && callback) {
  YILOG_TRACE ("func: {}", __func__);
  auto signup = chat::Register();
  signup.set_phoneno(phoneno);
  signup.set_countrycode(countrycode);
  netyi_->signup(yijian::buffer::Buffer(signup), [callback = std::forward<CB_Func>(callback)](const int8_t type, const std::string & data, bool * const isStop) {
    auto res = chat::RegisterRes();
    res.ParseFromString(data);
    if (res.issuccess()) {
      callback(0, netdb_success_);
    }else{
      callback(res.e_no(), res.e_msg());
    }
  });
}
void netdb_yi::regist(const std::string & phoneno, const std::string & countrycode, const std::string & password, const std::string & verifycode, CB_Func && callback) {
  YILOG_TRACE ("func: {}", __func__);
  auto signup = chat::Register();
  signup.set_phoneno(phoneno);
  signup.set_countrycode(countrycode);
  signup.set_password(password);
  signup.set_verifycode(verifycode);
  netyi_->signup(yijian::buffer::Buffer(signup), [this, phoneno, countrycode, password, callback = std::forward<CB_Func>(callback)](const int8_t type, const std::string & data, bool * const isStop) {
    auto res = chat::RegisterRes();
    res.ParseFromString(data);
    if (res.issuccess()) {
      this->login(phoneno, countrycode, password, [this, callback](const int err_no, const std::string & err_msg) {
        callback(err_no, err_msg);
      });
    }else{
      callback(res.e_no(), res.e_msg());
    }
  });
}
void netdb_yi::login(const std::string & phoneno, const std::string & countrycode, const std::string & password, CB_Func && callback) {
  YILOG_TRACE ("func: {}", __func__);
  auto login = chat::Login();
  login.set_phoneno(phoneno);
  login.set_countrycode(countrycode);
  login.set_password(password);
  auto md = login.mutable_device();
  (*md) = dbyi_->getCurrentDevice();
  netyi_->login(yijian::buffer::Buffer(login), [this, callback = std::forward<CB_Func>(callback)](int8_t type, const std::string & data, bool * isStop) {
    auto res = chat::LoginRes();
    res.ParseFromString(data);
    if (res.issuccess()) {
      this->connect(res.userid(), [this, callback](const int err_no, const std::string & err_msg) {
        callback(err_no, err_msg);
      });
    }else{
      callback(res.e_no(), res.e_msg());
    }
  });
}
void netdb_yi::connect(const std::string & userid, CB_Func && callback) {
  YILOG_TRACE ("func: {}", __func__);
  auto connect = chat::ClientConnect();
  connect.set_userid(userid);
  connect.set_uuid(udid_);
  connect.set_isrecivenoti(true);
  connect.set_clientversion("");
  connect.set_osversion(os_version_);
  connect.set_appversion(app_version_);
  netyi_->connect(yijian::buffer::Buffer(connect), [this, callback = std::forward<CB_Func>(callback)](int8_t type, const std::string & data, bool * isStop) {
    auto res = chat::ClientConnectRes();
    res.ParseFromString(data);
    if (res.issuccess()) {
      dbyi_->putCurrentUserid(res.userid());
      this->getUser(res.userid(), [this, callback](const int err_no, const std::string & err_msg) {
        callback(err_no, err_msg);
      });
    }else{
      callback(res.e_no(), res.e_msg());
    }
  });
}
void netdb_yi::disconnect(CB_Func && callback) {
  YILOG_TRACE ("func: {}", __func__);
  auto discon = chat::ClientDisConnect();
  discon.set_userid(dbyi_->getCurrentUserid());
  discon.set_uuid(udid_);
  netyi_->disconnect(yijian::buffer::Buffer(discon), [this, callback = std::forward<CB_Func>(callback)](int8_t type, const std::string & data, bool * isStop){
    if (ChatType::error == type) {
      auto err = chat::Error();
      err.ParseFromString(data);
      callback(err.errnum(), err.errmsg());
    }else{
      assert(ChatType::clientdisconnectres == type);
      callback(0, netdb_success_);
    }
  });
}
void netdb_yi::logout(CB_Func && callback) {
  YILOG_TRACE ("func: {}", __func__);
  auto logout = chat::Logout();
  logout.set_userid(dbyi_->getCurrentUserid());
  logout.set_uuid(udid_);
  netyi_->logout(yijian::buffer::Buffer(logout), [this, callback = std::forward<CB_Func>(callback)](int8_t type, const std::string & data, bool * isStop){
    callback(0, netdb_success_);
    if (ChatType::error == type) {
      auto err = chat::Error();
      err.ParseFromString(data);
      callback(err.errnum(), err.errmsg());
    }else{
      assert(ChatType::logoutres == type);
      dbyi_->deleteCurrentUserid();
      callback(0, netdb_success_);
    }
  });
}
  
void netdb_yi::userSetRealname(const std::string & realname, CB_Func && callback) {
  YILOG_TRACE ("func: {}", __func__);
  
}
void netdb_yi::userSetNickname(const std::string & nickname, CB_Func && callback) {
  YILOG_TRACE ("func: {}", __func__);
  
}
void netdb_yi::userSetIcon(const std::string & icon, CB_Func && callback) {
  YILOG_TRACE ("func: {}", __func__);
  
}
void netdb_yi::userSetIsmale(bool isMale, CB_Func && callback) {
  YILOG_TRACE ("func: {}", __func__);
  
}
void netdb_yi::userSetBirthday(int32_t birthdayTimestamp, CB_Func && callback) {
  YILOG_TRACE ("func: {}", __func__);
  
}
void netdb_yi::userSetDescription(const std::string & description, CB_Func && callback) {
  YILOG_TRACE ("func: {}", __func__);
  
}
  
void netdb_yi::addFriend(const std::string & friendid, const std::string & msg, CB_Func && callback) {
  YILOG_TRACE ("func: {}", __func__);
  auto query = chat::AddFriend();
  query.set_inviterid(dbyi_->getCurrentUserid());
  query.set_inviteeid(friendid);
  query.set_msg(msg);
  netyi_->send_buffer(yijian::buffer::Buffer(query), nullptr, [this, callback = std::forward<CB_Func>(callback)](int8_t type, const std::string & data, bool * isStop) {
    if (0 == type) {
      auto error = chat::Error();
      error.ParseFromString(data);
      callback(error.errnum(), error.errmsg());
    }else {
      assert(type == ChatType::addfriendres);
      auto res = chat::AddFriendRes();
      res.ParseFromString(data);
      callback(0, netdb_success_);
    }
  });
}
void netdb_yi::addFriendAuthorize(const std::string & friendid, const bool isAgree, CB_Func && callback) {
  YILOG_TRACE ("func: {}", __func__);
  auto query = chat::AddFriendAuthorize();
  query.set_inviterid(dbyi_->getCurrentUserid());
  query.set_inviteeid(friendid);
  if (isAgree) {
    query.set_isagree(chat::IsAgree::agree);
  }else {
    query.set_isagree(chat::IsAgree::refuse);
  }
  netyi_->send_buffer(yijian::buffer::Buffer(query), nullptr, [this, callback = std::forward<CB_Func>(callback)](int8_t type, const std::string & data, bool * isStop) {
    if (0 == type) {
      auto error = chat::Error();
      error.ParseFromString(data);
      callback(error.errnum(), error.errmsg());
    }else {
      assert(type == ChatType::addfriendauthorizeres);
      auto res = chat::AddFriendAuthorizeRes();
      res.ParseFromString(data);
      callback(0, netdb_success_);
    }
  });
  
}
void netdb_yi::getAddfriendInfo(CB_Func && callback) {
  YILOG_TRACE ("func: {}", __func__);
  auto query = chat::QueryAddfriendInfo();
  query.set_count(50);
  addfriendInfo_.Clear();
  netyi_->send_buffer(yijian::buffer::Buffer(query), nullptr, [this, callback = std::forward<CB_Func>(callback)](int8_t type, const std::string & data, bool * isStop) {
    if (0 == type) {
      auto error = chat::Error();
      error.ParseFromString(data);
      callback(error.errnum(), error.errmsg());
    }else {
      assert(type == ChatType::queryaddfriendinfores);
      auto res = chat::QueryAddfriendInfoRes();
      res.ParseFromString(data);
      if (res.isend()) {
        *isStop = false;
        dbyi_->putAddfriendInfo(addfriendInfo_);
        callback(0, netdb_success_);
      }else{
        auto info = addfriendInfo_.add_info();
        (*info) = res;
      }
    }
  });
}
  
void netdb_yi::getUser(const std::string & userid, CB_Func && callback) {
  YILOG_TRACE ("func: {}", __func__);
  auto query = chat::QueryUser();
  query.set_userid(userid);
  netyi_->send_buffer(yijian::buffer::Buffer(query), nullptr, [this, callback = std::forward<CB_Func>(callback)](int8_t type, const std::string & data, bool * isStop){
    if (0 == type) {
      auto error = chat::Error();
      error.ParseFromString(data);
      callback(error.errnum(), error.errmsg());
    }else {
      assert(type == ChatType::queryuserres);
      auto res = chat::QueryUserRes();
      res.ParseFromString(data);
      dbyi_->putUser(res.user());
      callback(0, netdb_success_);
    }
  });
}
void netdb_yi::getUser(const std::string & phone, const std::string & countrycode, CB_Func && callback) {
  YILOG_TRACE ("func: {}", __func__);
  auto query = chat::QueryUser();
  query.set_userid(phone);
  query.set_countrycode(countrycode);
  netyi_->send_buffer(yijian::buffer::Buffer(query), nullptr, [this, callback = std::forward<CB_Func>(callback)](int8_t type, const std::string & data, bool * isStop){
    if (0 == type) {
      auto error = chat::Error();
      error.ParseFromString(data);
      callback(error.errnum(), error.errmsg());
    }else {
      assert(type == ChatType::queryuserres);
      auto res = chat::QueryUserRes();
      res.ParseFromString(data);
      dbyi_->putUser(res.user());
      callback(0, netdb_success_);
    }
  });
}
  
