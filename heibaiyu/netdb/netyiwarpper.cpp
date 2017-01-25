//
//  netyiwarpper.cpp
//  heibaiyu
//
//  Created by jiwei.wang on 1/25/17.
//  Copyright © 2017 yijian. All rights reserved.
//

#include "netyiwarpper.h"
#include <stdio.h>
#include <stdint.h>
#include "net_yi.h"
#include "buffer_yi.h"
#include <string>

#ifdef __cplusplus
extern "C" {
#endif
 static netyi * netyic;
  
  int openyi_net(char * certpath, netyi::IsConnectSuccess isSuccess) {
    netyic = new netyi(std::string(certpath));
    netyic->net_connect(isSuccess);
    return 0;
  }
  
  int closeyi_net() {
    delete netyic;
    return 0;
  }
  
  int netyi_signup_login_conect(const uint8_t type, const uint8_t * header, const int32_t length,
                                Net_CB callback) {
    netyic->signup_login_connect(yijian::buffer::Buffer(type, reinterpret_cast<const char*>(header), length), callback);
    return 0;
  }
  int netyi_logout_disconnect(const uint8_t type, const uint8_t * header, const int32_t length,
                              Net_CB callback) {
    netyic->logout_disconnect(yijian::buffer::Buffer(type, reinterpret_cast<const char*>(header), length), callback);
    return 0;
  }
  int netyi_send(const uint8_t type, const uint8_t * header, const int32_t length,
                 Net_CB callback) {
    netyic->send_buffer(yijian::buffer::Buffer(type, reinterpret_cast<const char*>(header), length), callback);
    return 0;
  }
  int netyi_unread_msg_noti(Net_CB callback) {
    netyic->acceptUnreadMsg(callback);
    return 0;
  }
  int netyi_userinfo_noti(Net_CB callback) {
    netyic->userInfoNoti(callback);
    return 0;
  }
  
#ifdef __cplusplus
}
#endif
