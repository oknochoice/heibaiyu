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

static netyi * netyic;

@interface netyiwarpper ()

//@property (strong, nonatomic) IsConnectSuccess isSuccess;

@end

@implementation netyiwarpper
+ (BOOL)openyi_netWithcert:(NSString *)certpath with:(IsConnectSuccess)isSuccess {
  netyic = new netyi(std::string([certpath UTF8String]));
  netyic->net_connect(isSuccess);
  return true;
}
+ (BOOL)closeyi_net {
  delete netyic;
  return 0;
  return true;
}
+ (BOOL)netyi_signup_login_connectWith:(const uint8_t)type data:(NSString * )data cb:(Net_CB)callback {
  netyic->signup_login_connect(yijian::buffer::Buffer(type, std::string([data UTF8String])),
     [=](uint8_t type, std::string & data, bool * isStop){
       callback(type, [NSString stringWithCString:data.c_str() encoding: [NSString defaultCStringEncoding]], isStop);
  });
  return true;
}
+ (BOOL)netyi_logout_disconnectWith:(const uint8_t)type data:(NSString * )data cb:(Net_CB)callback {
  netyic->logout_disconnect(yijian::buffer::Buffer(type, std::string([data UTF8String])),
     [=](uint8_t type, std::string & data, bool * isStop){
       callback(type, [NSString stringWithCString:data.c_str() encoding: [NSString defaultCStringEncoding]], isStop);
  });
  return true;
}
+ (BOOL)netyi_sendWith:(const uint8_t)type data:(NSString * )data cb:(Net_CB)callback {
  netyic->send_buffer(yijian::buffer::Buffer(type, std::string([data UTF8String])),
     [=](uint8_t type, std::string & data, bool * isStop){
       callback(type, [NSString stringWithCString:data.c_str() encoding: [NSString defaultCStringEncoding]], isStop);
  });
  return true;
}
+ (BOOL)netyi_unread_msg_notiWith:(Net_CB)callback {
  netyic->acceptUnreadMsg(
     [=](uint8_t type, std::string & data, bool * isStop){
       callback(type, [NSString stringWithCString:data.c_str() encoding: [NSString defaultCStringEncoding]], isStop);
  });
  return true;
}
+ (BOOL)netyi_userinfo_notiWith:(Net_CB)callback {
  netyic->userInfoNoti(
     [=](uint8_t type, std::string & data, bool * isStop){
       callback(type, [NSString stringWithCString:data.c_str() encoding: [NSString defaultCStringEncoding]], isStop);
  });
  return true;
}
@end
