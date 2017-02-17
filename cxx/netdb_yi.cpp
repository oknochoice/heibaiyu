//
//  netdb_yi.cpp
//  heibaiyu
//
//  Created by jiwei.wang on 2/9/17.
//  Copyright © 2017 yijian. All rights reserved.
//

#include "netdb_yi.hpp"
#include "buffer_yi_util.hpp"
#include <openssl/sha.h>

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

void netdb_yi::openNet(Client_CB client_callback, CB_Func && pongback) {
  YILOG_TRACE ("func: {}", __func__);
  if (isOpenNet_.load()) {
    return;
  }
  netyi_ = new netyi(certpath_);
  client_callback_ = client_callback;
  auto ping = chat::Ping();
  ping.set_msg("ping");
  /*
#ifdef DEBUG
  ping.set_msg("pingpingpingpingpingpingpingpingpingpingpingpingpingpingpingpingping"
               "pingpingpingpingpingpingpingpingpingpingpingpingpingpingpingpingping"
               "pingpingpingpingpingpingpingpingpingpingpingpingpingpingpingpingping"
               "pingpingpingpingpingpingpingpingpingpingpingpingpingpingpingpingping"
               "pingpingpingpingpingpingpingpingpingpingpingpingpingpingpingpingping"
               "pingpingpingpingpingpingpingpingpingpingpingpingpingpingpingpingping"
               "pingpingpingpingpingpingpingpingpingpingpingpingpingpingpingpingping"
               "pingpingpingpingpingpingpingpingpingpingpingpingpingpingpingpingping"
               "pingpingpingpingpingpingpingpingpingpingpingpingpingpingpingpingping"
               "pingpingpingpingpingpingpingpingpingpingpingpingpingpingpingpingping"
               "pingpingpingpingpingpingpingpingpingpingpingpingpingpingpingpingping"
               "pingpingpingpingpingpingpingpingpingpingpingpingpingpingpingpingping"
               "pingpingpingpingpingpingpingpingpingpingpingpingpingpingpingpingping"
               "pingpingpingpingpingpingpingpingpingpingpingpingpingpingpingpingping"
               "pingpingpingpingpingpingpingpingpingpingpingpingpingpingpingpingping"
               "pingpingpingpingpingpingpingpingpingpingpingpingpingpingpingpingping"
               "pingpingpingpingpingpingpingpingpingpingpingpingpingpingpingpingping"
               "pingpingpingpingpingpingpingpingpingpingpingpingpingpingpingpingping"
               "pingpingpingpingpingpingpingpingpingpingpingpingpingpingpingpingping"
               "pingpingpingpingpingpingpingpingpingpingpingpingpingpingpingpingping"
               "pingpingpingpingpingpingpingpingpingpingpingpingpingpingpingpingping"
               "pingpingpingpingpingpingpingpingpingpingpingpingpingpingpingpingping"
               "pingpingpingpingpingpingpingpingpingpingpingpingpingpingpingpingping"
               "pingpingpingpingpingpingpingpingpingpingpingpingpingpingpingpingping"
               "pingpingpingpingpingpingpingpingpingpingpingpingpingpingpingpingping"
               "pingpingpingpingpingpingpingpingpingpingpingpingpingpingpingpingping"
               "pingpingpingpingpingpingpingpingpingpingpingpingpingpingpingpingping"
               "pingpingpingpingpingpingpingpingpingpingpingpingpingpingpingpingping"
               "pingpingpingpingpingpingpingpingpingpingpingpingpingpingpingpingping"
               "pingpingpingpingpingpingpingpingpingpingpingpingpingpingpingpingping"
               "pingpingpingpingpingpingpingpingpingpingpingpingpingpingpingpingping"
               "pingpingpingpingpingpingpingpingpingpingpingpingpingpingpingpingping"
               "pingpingpingpingpingpingpingpingpingpingpingpingpingpingpingpingping"
               "pingpingpingpingpingpingpingpingpingpingpingpingpingpingpingpingping"
               "pingpingpingpingpingpingpingpingpingpingpingpingpingpingpingpingping"
               "pingpingpingpingpingpingpingpingpingpingpingpingpingpingpingpingping"
               "pingpingpingpingpingpingpingpingpingpingpingpingpingpingpingpingping"
               "pingpingpingpingpingpingpingpingpingpingpingpingpingpingpingpingping"
               "pingpingpingpingpingpingpingpingpingpingpingpingpingpingpingpingping"
               "pingpingpingpingpingpingpingpingpingpingpingpingpingpingpingpingping"
               "pingpingpingpingpingpingpingpingpingpingpingpingpingpingpingpingping"
               "pingpingpingpingpingpingpingpingpingpingpingpingpingpingpingpingping"
               "pingpingpingpingpingpingpingpingpingpingpingpingpingpingpingpingping"
               "pingpingpingpingpingpingpingpingpingpingpingpingpingpingpingpingping"
               "pingpingpingpingpingpingpingpingpingpingpingpingpingpingpingpingping"
               "pingpingpingpingpingpingpingpingpingpingpingpingpingpingpingpingping"
               "pingpingpingpingpingpingpingpingpingpingpingpingpingpingpingpingping"
               "pingpingpingpingpingpingpingpingpingpingpingpingpingpingpingpingping"
               "pingpingpingpingpingpingpingpingpingpingpingpingpingpingpingpingping");
#endif
   */
  netyi_->setNetIsReachable(true);
  netyi_->net_connect(yijianBuffer(ping), [this](const int error_no, const std::string & error_msg) {
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
  }, [pongback = std::forward<CB_Func>(pongback)](const int8_t type, const std::string & data, bool * const isStop){
    if (!pongback) {
      return ;
    }
    if (0 == type) {
      auto error = chat::Error();
      error.ParseFromString(data);
      pongback(error.errnum(), error.errmsg());
    }else {
      Assert(type == ChatType::pong);
      auto res = chat::Pong();
      res.ParseFromString(data);
      pongback(0, res.msg());
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
  netyi_->signup(yijianBuffer(signup), [callback = std::forward<CB_Func>(callback)](const int8_t type, const std::string & data, bool * const isStop) {
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
  netyi_->signup(yijianBuffer(signup), [this, phoneno, countrycode, password, callback = std::forward<CB_Func>(callback)](const int8_t type, const std::string & data, bool * const isStop) {
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
  netyi_->login(yijianBuffer(login), [this, callback = std::forward<CB_Func>(callback)](int8_t type, const std::string & data, bool * isStop) {
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
  netyi_->connect(yijianBuffer(connect), [this, callback = std::forward<CB_Func>(callback)](int8_t type, const std::string & data, bool * isStop) {
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
  netyi_->disconnect(yijianBuffer(discon), [this, callback = std::forward<CB_Func>(callback)](int8_t type, const std::string & data, bool * isStop){
    if (ChatType::error == type) {
      auto err = chat::Error();
      err.ParseFromString(data);
      callback(err.errnum(), err.errmsg());
    }else{
      Assert(ChatType::clientdisconnectres == type);
      callback(0, netdb_success_);
    }
  });
}
void netdb_yi::logout(CB_Func && callback) {
  YILOG_TRACE ("func: {}", __func__);
  auto logout = chat::Logout();
  logout.set_userid(dbyi_->getCurrentUserid());
  logout.set_uuid(udid_);
  netyi_->logout(yijianBuffer(logout), [this, callback = std::forward<CB_Func>(callback)](int8_t type, const std::string & data, bool * isStop){
    callback(0, netdb_success_);
    if (ChatType::error == type) {
      auto err = chat::Error();
      err.ParseFromString(data);
      callback(err.errnum(), err.errmsg());
    }else{
      Assert(ChatType::logoutres == type);
      dbyi_->deleteCurrentUserid();
      callback(0, netdb_success_);
    }
  });
}
  
void netdb_yi::setUserProterty(const chat::SetUserProperty & proterty, CB_Func && callback) {
  YILOG_TRACE ("func: {}", __func__);
  netyi_->send_buffer(yijianBuffer(proterty), nullptr, [this, callback = std::forward<CB_Func>(callback)](int8_t type, const std::string & data, bool * isStop) {
    if (0 == type) {
      auto error = chat::Error();
      error.ParseFromString(data);
      callback(error.errnum(), error.errmsg());
    }else {
      Assert(type == ChatType::setuserprotertyres);
    }
  });
}
void netdb_yi::userSetRealname(const std::string & realname, CB_Func && callback) {
  YILOG_TRACE ("func: {}", __func__);
  auto property = chat::SetUserProperty();
  property.set_property(chat::UserProperty::realname);
  property.set_value(realname);
  setUserProterty(property, std::forward<CB_Func>(callback));
}
void netdb_yi::userSetNickname(const std::string & nickname, CB_Func && callback) {
  YILOG_TRACE ("func: {}", __func__);
  auto property = chat::SetUserProperty();
  property.set_property(chat::UserProperty::nickname);
  property.set_value(nickname);
  setUserProterty(property, std::forward<CB_Func>(callback));
}
void netdb_yi::userSetIcon(const std::string & icon, CB_Func && callback) {
  YILOG_TRACE ("func: {}", __func__);
  auto property = chat::SetUserProperty();
  property.set_property(chat::UserProperty::icon);
  property.set_value(icon);
  setUserProterty(property, std::forward<CB_Func>(callback));
}
void netdb_yi::userSetIsmale(bool isMale, CB_Func && callback) {
  YILOG_TRACE ("func: {}", __func__);
  auto property = chat::SetUserProperty();
  property.set_property(chat::UserProperty::isMale);
  if (isMale) {
    property.set_value("true");
  }else{
    property.set_value("false");
  }
  setUserProterty(property, std::forward<CB_Func>(callback));
}
void netdb_yi::userSetBirthday(int32_t birthdayTimestamp, CB_Func && callback) {
  YILOG_TRACE ("func: {}", __func__);
  auto property = chat::SetUserProperty();
  property.set_property(chat::UserProperty::birthday);
  property.set_value(std::to_string(birthdayTimestamp));
  setUserProterty(property, std::forward<CB_Func>(callback));
}
void netdb_yi::userSetDescription(const std::string & description, CB_Func && callback) {
  YILOG_TRACE ("func: {}", __func__);
  auto property = chat::SetUserProperty();
  property.set_property(chat::UserProperty::description);
  property.set_value(description);
  setUserProterty(property, std::forward<CB_Func>(callback));
}

void netdb_yi::addFriend(const std::string & friendid, const std::string & msg, CB_Func && callback) {
  YILOG_TRACE ("func: {}", __func__);
  auto query = chat::AddFriend();
  query.set_inviterid(dbyi_->getCurrentUserid());
  query.set_inviteeid(friendid);
  query.set_msg(msg);
  netyi_->send_buffer(yijianBuffer(query), nullptr, [this, callback = std::forward<CB_Func>(callback)](int8_t type, const std::string & data, bool * isStop) {
    if (0 == type) {
      auto error = chat::Error();
      error.ParseFromString(data);
      callback(error.errnum(), error.errmsg());
    }else {
      Assert(type == ChatType::addfriendres);
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
  netyi_->send_buffer(yijianBuffer(query), nullptr, [this, callback = std::forward<CB_Func>(callback)](int8_t type, const std::string & data, bool * isStop) {
    if (0 == type) {
      auto error = chat::Error();
      error.ParseFromString(data);
      callback(error.errnum(), error.errmsg());
    }else {
      Assert(type == ChatType::addfriendauthorizeres);
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
  netyi_->send_buffer(yijianBuffer(query), nullptr, [this, callback = std::forward<CB_Func>(callback)](int8_t type, const std::string & data, bool * isStop) {
    if (0 == type) {
      auto error = chat::Error();
      error.ParseFromString(data);
      callback(error.errnum(), error.errmsg());
    }else {
      Assert(type == ChatType::queryaddfriendinfores);
      auto res = chat::QueryAddfriendInfoRes();
      res.ParseFromString(data);
      dbyi_->putAddfriendInfo(res);
      callback(0, netdb_success_);
    }
  });
}
  
void netdb_yi::getUser(const std::string & userid, CB_Func && callback) {
  YILOG_TRACE ("func: {}", __func__);
  // get db user
  int32_t version = 0;
  try {
    auto user = dbyi_->getUser(userid);
    version = user.version();
  } catch (...) {
  }
  // query user version
  auto query = chat::QueryUserVersion();
  query.set_userid(userid);
  netyi_->send_buffer(yijianBuffer(query), nullptr, [this, version, userid, callback = std::forward<CB_Func>(callback)](int8_t type, const std::string & data, bool * isStop) {
    if (0 == type) {
      auto error = chat::Error();
      error.ParseFromString(data);
      callback(error.errnum(), error.errmsg());
    }else {
      Assert(type == ChatType::queryuserversionres);
      auto res = chat::QueryUserVersionRes();
      res.ParseFromString(data);
      if (version < res.version()) {
        auto query = chat::QueryUser();
        query.set_userid(userid);
        netyi_->send_buffer(yijianBuffer(query), nullptr, [this, callback](int8_t type, const std::string & data, bool * isStop){
          if (0 == type) {
            auto error = chat::Error();
            error.ParseFromString(data);
            callback(error.errnum(), error.errmsg());
          }else {
            Assert(type == ChatType::queryuserres);
            auto res = chat::QueryUserRes();
            res.ParseFromString(data);
            dbyi_->putUser(res.user());
            callback(0, netdb_success_);
          }
        });
      }else {
        callback(0, netdb_success_);
      }
    }
  });
}
void netdb_yi::getUser(const std::string & phone, const std::string & countrycode, CB_Func && callback) {
  YILOG_TRACE ("func: {}", __func__);
  auto query = chat::QueryUser();
  query.set_userid(phone);
  query.set_countrycode(countrycode);
  netyi_->send_buffer(yijianBuffer(query), nullptr, [this, callback = std::forward<CB_Func>(callback)](int8_t type, const std::string & data, bool * isStop){
    if (0 == type) {
      auto error = chat::Error();
      error.ParseFromString(data);
      callback(error.errnum(), error.errmsg());
    }else {
      Assert(type == ChatType::queryuserres);
      auto res = chat::QueryUserRes();
      res.ParseFromString(data);
      dbyi_->putUser(res.user());
      callback(0, netdb_success_);
    }
  });
}
/*
 * media
 */
void netdb_yi::setMediaPath(const std::string & sha1, const std::string & path, CB_Func && callback) {
  YILOG_TRACE ("func: {}", __func__);
  auto media = chat::Media();
  media.set_sha1(sha1);
  media.set_path(path);
  netyi_->send_buffer(yijianBuffer(media), nullptr, [this, callback = std::forward<CB_Func>(callback), &media](int8_t type, const std::string & data, bool * isStop) {
    if (0 == type) {
      auto error = chat::Error();
      error.ParseFromString(data);
      callback(error.errnum(), error.errmsg());
    }else {
      Assert(type == ChatType::mediares);
      dbyi_->putMediaPath(media);
    }
  });
}

void netdb_yi::getMediaPath(const std::string & sha1, CB_Func &&callback) {
  YILOG_TRACE ("func: {}", __func__);
  try {
    dbyi_->getMediaPath(sha1);
    callback(0, netdb_success_);
  } catch (...) {
    auto query = chat::QueryMedia();
    query.set_sha1(sha1);
    netyi_->send_buffer(yijianBuffer(query), nullptr, [this, callback = std::forward<CB_Func>(callback)](int8_t type, const std::string & data, bool * isStop) {
      if (0 == type) {
        auto error = chat::Error();
        error.ParseFromString(data);
        callback(error.errnum(), error.errmsg());
      }else {
        Assert(type == ChatType::querymediares);
        auto res = chat::QueryMediaRes();
        dbyi_->putMediaPath(res.media());
        callback(0, netdb_success_);
      }
    });
  }
}
  

/*
 * message
 */
void netdb_yi::sendMessage(const std::string & toNodeID, const int32_t type,
                           const std::string & content, CB_Func && callback) {
  YILOG_TRACE ("func: {}", __func__);
  auto message = chat::NodeMessage();
  message.set_fromuserid(dbyi_->getCurrentUserid());
  message.set_tonodeid(toNodeID);
  message.set_type(static_cast<chat::MediaType>(type));
  message.set_content(content);
  netyi_->send_buffer(yijianBuffer(message), nullptr, [this, callback = std::forward<CB_Func>(callback), &message](int8_t type, const std::string & data, bool * isStop) {
    if (0 == type) {
      auto error = chat::Error();
      error.ParseFromString(data);
      callback(error.errnum(), error.errmsg());
    }else {
      Assert(type == ChatType::nodemessageres);
      auto res = chat::NodeMessageRes();
      message.set_id(res.id());
      message.set_incrementid(res.incrementid());
      dbyi_->putMessage(message);
      callback(0, netdb_success_);
    }
  });
}
void netdb_yi::queryOneMessage(const std::string & tonodeid, const int32_t increment, CB_Func && callback) {
  YILOG_TRACE ("func: {}", __func__);
  auto query = chat::QueryOneMessage();
  query.set_tonodeid(tonodeid);
  query.set_incrementid(increment);
  netyi_->send_buffer(yijianBuffer(query), nullptr, [this, callback = std::forward<CB_Func>(callback)](int8_t type, const std::string & data, bool * isStop) {
    if (0 == type) {
      auto error = chat::Error();
      error.ParseFromString(data);
      callback(error.errnum(), error.errmsg());
    }else {
      Assert(type == ChatType::querymessageres);
      auto res = chat::QueryMessageRes();
      res.ParseFromString(data);
      for (auto & msg: res.messages()) {
        dbyi_->putMessage(msg);
      }
      callback(0, netdb_success_);
    }
  });
}
void netdb_yi::queryMessage(const std::string & tonodeid, const int32_t fromIncrement,
                            const int32_t toIncrement, CB_Func && callback) {
  YILOG_TRACE ("func: {}", __func__);
  auto query = chat::QueryMessage();
  query.set_tonodeid(tonodeid);
  query.set_fromincrementid(fromIncrement);
  query.set_toincrementid(toIncrement);
  netyi_->send_buffer(yijianBuffer(query), nullptr, [this, callback = std::forward<CB_Func>(callback)](int8_t type, const std::string & data, bool * isStop) {
    if (0 == type) {
      auto error = chat::Error();
      error.ParseFromString(data);
      callback(error.errnum(), error.errmsg());
    }else {
      Assert(type == ChatType::querymediares);
      auto res = chat::QueryMessageRes();
      res.ParseFromString(data);
      for (auto & msg: res.messages()) {
        dbyi_->putMessage(msg);
      }
      callback(0, netdb_success_);
    }
  });
}
