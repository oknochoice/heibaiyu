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
#include "leveldb_yi.hpp"

class netdb_yi {
  
public:
  
  // type < 0, type == err_no data == err_msg 
  typedef std::function<void(int16_t type, std::string & data)>
    CB_Func;
  netdb_yi(std::string & dbpath);
  ~netdb_yi();
  
  /*
   * user
   */
  void openNet(std::string & certpath, Client_CB client_callback);
  void registCheck(std::string & phoneno, std::string & countrycode, CB_Func client_callback);
  void regist(std::string & phoneno, std::string & countrycode, std::string & verifycode);
  void login(std::string & phoneno, std::string & countrycode, std::string & password);
  void connect(std::string & phoneno, std::string & countrycode, std::string & password);
  void disconnect();
  void logout();
  
  void userSetRealname(std::string & realname);
  void userSetNickname(std::string & nickname);
  void userSetIcon(std::string & icon);
  void userSetIsmale(bool isMale);
  void userSetBirthday(int32_t birthdayTimestamp);//seconds
  void userSetDescription(std::string & description);
  
  void addFriend(std::string & friendid);
  void addFriendAuthorize(std::string & friendid);
  void getAddfriendInfo();
  
  void getCurrentUser();
  
private:
  std::atomic_bool isOpenNet_;
  netyi * netyi_;
  leveldb_yi * dbyi_;
  Client_CB client_callback_;
};

#endif /* netdb_yi_hpp */
