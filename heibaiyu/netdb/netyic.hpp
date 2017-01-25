//
//  netyic.hpp
//  heibaiyu
//
//  Created by jiwei.wang on 1/25/17.
//  Copyright © 2017 yijian. All rights reserved.
//

#ifndef netyic_hpp
#define netyic_hpp

#include <stdio.h>
#include <stdint.h>
#include "net_yi.h"
#ifdef __cplusplus
extern "C" {
#endif

  typedef void (*Net_CB)(uint8_t type, const char * header,
    const int32_t length, bool * isStop);
  
 extern int open_netyi(netyi::IsConnectSuccess isSuccess);
  int close_netyi();
  
  int netyi_signup_login_conect(
          const uint8_t type, const char * header, const int32_t length,
          Net_CB callback);
  int netyi_logout_disconnect(
          const uint8_t type, const char * header, const int32_t length,
          Net_CB callback);
  int netyi_send(
          const uint8_t type, const char * header, const int32_t length,
          Net_CB callback);
  
  int netyi_unread_msg_noti(Net_CB callback);
  int netyi_userinfo_noti(Net_CB callback);
    
#ifdef __cplusplus
}
#endif
#endif /* netyic_hpp */
