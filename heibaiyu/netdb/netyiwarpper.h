//
//  netyiwarpper.h
//  heibaiyu
//
//  Created by jiwei.wang on 1/25/17.
//  Copyright © 2017 yijian. All rights reserved.
//

#ifndef netyiwarpper_h
#define netyiwarpper_h

#include <stdint.h>
#ifdef __cplusplus
extern "C" {
#endif
  typedef void (*Net_CB)(uint8_t type, const uint8_t * header,
    const int32_t length, bool * isStop);
  
  typedef void (*IsConnectSuccess)(bool);
  
  int openyi_net(char * certpath, IsConnectSuccess isSuccess);
  
  int closeyi_net() ;
  
  int netyi_signup_login_conect(const uint8_t type, const uint8_t * header, const int32_t length,
                                Net_CB callback);
  int netyi_logout_disconnect(const uint8_t type, const uint8_t * header, const int32_t length,
                              Net_CB callback);
  int netyi_send(const uint8_t type, const uint8_t * header, const int32_t length,
                 Net_CB callback);
  int netyi_unread_msg_noti(Net_CB callback) ;
  int netyi_userinfo_noti(Net_CB callback);
  
#ifdef __cplusplus
}
#endif

#endif /* netyiwarpper_h */
