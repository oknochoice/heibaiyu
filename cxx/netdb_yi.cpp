//
//  netdb_yi.cpp
//  heibaiyu
//
//  Created by jiwei.wang on 2/9/17.
//  Copyright © 2017 yijian. All rights reserved.
//

#include "netdb_yi.hpp"


netdb_yi::netdb_yi(std::string & dbpath) {
  YILOG_TRACE ("func: {}", __func__);
  isOpenNet_.store(false);
  leveldb::Options options;
  options.create_if_missing = true;
  leveldb::Status status = leveldb::DB::Open(options, dbpath, &db_);

  if (!status.ok()) {
    throw std::system_error(std::error_code(50000, 
          std::generic_category()),
       "open db failure");
  }

}

netdb_yi::~netdb_yi() {
  YILOG_TRACE ("func: {}", __func__);
  if (isOpenNet_.load()) {
    clear_client();
  }
  delete db_;
}

void netdb_yi::openNet(std::string & certpath) {
  YILOG_TRACE ("func: {}", __func__);
  netyi_ = new netyi(certpath);
}

// common
leveldb::Status netdb_yi::put(const leveldb::Slice & key, 
    const leveldb::Slice & value) {
  YILOG_TRACE ("func: {}", __func__);
  return db_->Put(leveldb::WriteOptions(), key, value);
}
leveldb::Status netdb_yi::get(const leveldb::Slice & key, 
    std::string & value) {
  YILOG_TRACE ("func: {}", __func__);
  return db_->Get(leveldb::ReadOptions(), key, &value);
}

std::string netdb_yi::userKey(const std::string & userid) {
  YILOG_TRACE ("func: {}", __func__);
  return "u_" + userid;
}
std::string netdb_yi::nodeKey(const std::string & tonodeid) {
  YILOG_TRACE ("func: {}", __func__);
  return "n_" + tonodeid;
}
std::string netdb_yi::msgKey(const std::string & tonodeid,
    const std::string & incrementid) {
  YILOG_TRACE ("func: {}", __func__);
  return "m_" + tonodeid + "_" + incrementid;
}
std::string netdb_yi::msgKey(const std::string & tonodeid,
    const int32_t incrementid) {
  return msgKey(tonodeid, std::to_string(incrementid));
}
std::string netdb_yi::userPhoneKey(const std::string & countrycode,
    const std::string phoneno) {
  YILOG_TRACE ("func: {}", __func__);
  return "p_" + countrycode + "_" + phoneno;
}
std::string netdb_yi::errorKey(const std::string & userid,
    const int32_t  nth) {
  YILOG_TRACE ("func: {}", __func__);
  return "e_" + userid + "_" + std::to_string(nth);
}
std::string netdb_yi::talklistKey(const std::string & userid) {
  YILOG_TRACE ("func: {}", __func__);
  return "t_" + userid;
}


std::string netdb_yi::signupKey() {
  YILOG_TRACE ("func: {}", __func__);
  return "signup_netdb_yi";
}
std::string netdb_yi::loginKey() {
  YILOG_TRACE ("func: {}", __func__);
  return "login_netdb_yi";
}
std::string netdb_yi::logoutKey() {
  YILOG_TRACE ("func: {}", __func__);
  return "logout_netdb_yi";
}
std::string netdb_yi::connectKey() {
  YILOG_TRACE ("func: {}", __func__);
  return "connect_netdb_yi";
}
std::string netdb_yi::disconnectKey() {
  YILOG_TRACE ("func: {}", __func__);
  return "disconnect_netdb_yi";
}
std::string netdb_yi::loginNotiKey() {
  YILOG_TRACE ("func: {}", __func__);
  return "loginnoti_netdb_yi";
}
std::string netdb_yi::addFriendNotiKey() {
  YILOG_TRACE ("func: {}", __func__);
  return "addfriendnoti_netdb_yi";
}
std::string netdb_yi::addFriendAuthorizeNotiKey() {
  YILOG_TRACE ("func: {}", __func__);
  return "addfriendauthorizenoti_netdb_yi";
}
std::string netdb_yi::addFriendInfoKey() {
  YILOG_TRACE ("func: {}", __func__);
  return "addfriendinfo_netdb_yi";
}
