//
//  netdb_yi.hpp
//  heibaiyu
//
//  Created by jiwei.wang on 2/9/17.
//  Copyright © 2017 yijian. All rights reserved.
//

#ifndef netdb_yi_hpp
#define netdb_yi_hpp

#include <stdio.h>
#include "macro.h"
#include <leveldb/db.h>
#include <google/chat_message.pb.h>
#include "net_yi.h"

class netdb_yi {
  
public:
  // 50000 50040
  
  netdb_yi(std::string & dbpath);
  ~netdb_yi();
  
  void openNet(std::string & certpath);
  
  /*
   * common leveldb put get
   *
   * */
  leveldb::Status put(const leveldb::Slice & key, 
      const leveldb::Slice & value);
  leveldb::Status get(const leveldb::Slice & key, 
      std::string & value);

  /*
   * common compose key
   *
   * */
  // u_$userid
  std::string userKey(const std::string & userid);
  // n_$tonodeid
  std::string nodeKey(const std::string & tonodeid);
  // m_$tonodeid_$incrementid
  std::string msgKey(const std::string & tonodeid,
      const std::string & incrementid);
  std::string msgKey(const std::string & tonodeid,
      const int32_t incrementid);
  // p_$code_$phoneno
  std::string userPhoneKey(const std::string & countrycode,
      const std::string phoneno);
  // e_userid_$nth
  std::string errorKey(const std::string & userid,
      const int32_t nth);
  // t_&userid
  std::string talklistKey(const std::string & userid);

  // signup_kvdb
  std::string signupKey();
  // login_kvdb
  std::string loginKey();
  // logout_kvdb
  std::string logoutKey();
  // connect_kvdb
  std::string connectKey();
  // disconnect_kvdb
  std::string disconnectKey();
  // loginnoti_kvdb
  std::string loginNotiKey();
  // addfriendnoti_kvdb
  std::string addFriendNotiKey();
  // addfriendauthorizenoti_kvdb
  std::string addFriendAuthorizeNotiKey();
  // addfriendinfo_kvdb 
  std::string addFriendInfoKey();

private:
  leveldb::DB * db_;
  std::atomic_bool isOpenNet_;
  netyi * netyi_;
};

#endif /* netdb_yi_hpp */
