//
//  leveldb_yi.cpp
//  heibaiyu
//
//  Created by jiwei.wang on 2/10/17.
//  Copyright © 2017 yijian. All rights reserved.
//

#include "leveldb_yi.hpp"
#include <leveldb/db.h>
#include <leveldb/write_batch.h>
#include <system_error>
#include "macro.h"

leveldb_yi::leveldb_yi(const std::string & dbpath) {
  leveldb::Options options;
  options.create_if_missing = true;
  leveldb::Status status = leveldb::DB::Open(options, dbpath, &db_);

  if (!status.ok()) {
    throw std::system_error(std::error_code(50000, 
          std::generic_category()),
       "open db failure");
  }
  
}

leveldb_yi::~leveldb_yi() {
  delete db_;
}

/*
 * user
 *
 * */
void leveldb_yi::putUser(const chat::User & user) {
  YILOG_TRACE ("func: {}", __func__);
  if (user.id().empty() || user.countrycode().empty() || user.phoneno().empty()) {
    throw std::system_error(std::error_code(50004,
          std::generic_category()),
        "parameter is empty");
  }
  auto userkey = userKey(user.id());
  auto phonekey = userPhoneKey(user.countrycode(), user.phoneno());
  leveldb::WriteBatch batch;
  batch.Put(phonekey, user.id());
  batch.Put(userkey, user.SerializeAsString());
  put(batch);
}

chat::User leveldb_yi::getUser(const std::string & id) {
  YILOG_TRACE ("func: {}", __func__);
  auto key = userKey(id);
  auto user_s = get(key);
  auto user = chat::User();
  user.ParseFromString(user_s);
  return user;
}

chat::User leveldb_yi::getUser(const std::string & countrycode,
                               const std::string & phoneno) {
  YILOG_TRACE ("func: {}", __func__);
  auto key = userPhoneKey(countrycode, phoneno);
  auto userid = get(key);
  return getUser(userid);
}

chat::User leveldb_yi::getCurrentUser() {
  YILOG_TRACE ("func: {}", __func__);
  return getUser(getCurrentUserid());
}
/*
 * add friend info
 */
void leveldb_yi::putAddfriendInfo(const chat::AddFriendInfo & info) {
  auto key = addFriendInfoKey();
  put(key, info.SerializeAsString());
}
chat::AddFriendInfo leveldb_yi::getAddfriendInfo() {
  auto info_s = get(addFriendInfoKey());
  auto info = chat::AddFriendInfo();
  info.ParseFromString(info_s);
  return info;
}
/*
 * private
 */
// common
void leveldb_yi::put(const leveldb::Slice & key,
    const leveldb::Slice & value) {
  YILOG_TRACE ("func: {}", __func__);
  leveldb::WriteOptions write_options;
  auto status =  db_->Put(write_options, key, value);
  if (unlikely(!status.ok())) {
    throw std::system_error(std::error_code(50001,
          std::generic_category()),
        "put failure");
  }
}
std::string leveldb_yi::get(const leveldb::Slice & key) {
  YILOG_TRACE ("func: {}", __func__);
  std::string value;
  auto status = db_->Get(leveldb::ReadOptions(), key, &value);
  if (unlikely(!status.ok())) {
    throw std::system_error(std::error_code(50002,
          std::generic_category()),
        "get failure");
  }
  return value;
}
void leveldb_yi::put(leveldb::WriteBatch & batch) {
  YILOG_TRACE ("func: {}", __func__);
  auto status = db_->Write(leveldb::WriteOptions(), &batch);
  if (unlikely(!status.ok())) {
    throw std::system_error(std::error_code(50003,
          std::generic_category()),
        "put batch failure");
  }
}
/*
 * current 
 *
 * */
void leveldb_yi::setCurrentUserid(const std::string & userid) {
  YILOG_TRACE ("func: {}", __func__);
  put("current_user", userid);
}
std::string leveldb_yi::getCurrentUserid() {
  YILOG_TRACE ("func: {}", __func__);
  return get("current_user");
}

std::string leveldb_yi::userKey(const std::string & userid) {
  YILOG_TRACE ("func: {}", __func__);
  return "u_" + userid;
}
std::string leveldb_yi::userPhoneKey(const std::string & countrycode,
    const std::string phoneno) {
  YILOG_TRACE ("func: {}", __func__);
  return "p_" + countrycode + "_" + phoneno;
}
std::string leveldb_yi::addFriendInfoKey() {
  YILOG_TRACE ("func: {}", __func__);
  return "addfriendinfo_leveldb_yi_" + getCurrentUserid();
}

std::string leveldb_yi::nodeKey(const std::string & tonodeid) {
  YILOG_TRACE ("func: {}", __func__);
  return "n_" + tonodeid;
}
std::string leveldb_yi::msgKey(const std::string & tonodeid,
    const std::string & incrementid) {
  YILOG_TRACE ("func: {}", __func__);
  return "m_" + tonodeid + "_" + incrementid;
}
std::string leveldb_yi::msgKey(const std::string & tonodeid,
    const int32_t incrementid) {
  return msgKey(tonodeid, std::to_string(incrementid));
}
std::string leveldb_yi::talklistKey() {
  YILOG_TRACE ("func: {}", __func__);
  return "t_" + getCurrentUserid();
}


/*
std::string leveldb_yi::errorKey(const std::string & userid,
    const int32_t  nth) {
  YILOG_TRACE ("func: {}", __func__);
  return "e_" + userid + "_" + std::to_string(nth);
}
std::string leveldb_yi::signupKey() {
  YILOG_TRACE ("func: {}", __func__);
  return "signup_leveldb_yi";
}
std::string leveldb_yi::loginKey() {
  YILOG_TRACE ("func: {}", __func__);
  return "login_leveldb_yi";
}
std::string leveldb_yi::logoutKey() {
  YILOG_TRACE ("func: {}", __func__);
  return "logout_leveldb_yi";
}
std::string leveldb_yi::connectKey() {
  YILOG_TRACE ("func: {}", __func__);
  return "connect_leveldb_yi";
}
std::string leveldb_yi::disconnectKey() {
  YILOG_TRACE ("func: {}", __func__);
  return "disconnect_leveldb_yi";
}
std::string leveldb_yi::loginNotiKey() {
  YILOG_TRACE ("func: {}", __func__);
  return "loginnoti_leveldb_yi";
}
std::string leveldb_yi::addFriendNotiKey() {
  YILOG_TRACE ("func: {}", __func__);
  return "addfriendnoti_leveldb_yi";
}
std::string leveldb_yi::addFriendAuthorizeNotiKey() {
  YILOG_TRACE ("func: {}", __func__);
  return "addfriendauthorizenoti_leveldb_yi";
}
 */
