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
#include "typemap.h"

static netyi * netyic = nullptr;
static bool isNetWorking_ = false;

@interface netyiwarpper ()

//@property (strong, nonatomic) IsConnectSuccess isSuccess;

@end

@implementation netyiwarpper
+ (void)openyi_netWithcert:(NSString *)certpath with:(NSString *)ping with:(IsConnectSuccess)isSuccess with:(Error_Block)error {
  netyic = new netyi(std::string([certpath UTF8String]));
  netyic->setNetIsReachable(true);
  netyic->net_connect(yijian::buffer::Buffer(ChatType::ping, std::string([ping UTF8String])) ,
    isSuccess, [=](int error_no, std::string error_msg) {
    error(error_no, [NSString stringWithCString:error_msg.c_str() encoding:NSUTF8StringEncoding]);
  });
}
+ (BOOL)netyi_isOpened {
  return netyic != nullptr;
}
+ (void)netyi_net_isConnect:(BOOL)isConnect {
  if (netyic) {
    isNetWorking_ = isConnect;
    netyic->setNetIsReachable(isConnect);
  }
}
+ (void)closeyi_net {
  delete netyic;
  netyic = nullptr;
}
+ (void)netyi_signup_login_connectWith:(const uint8_t)type data:(NSString * )data cb:(Net_CB)callback {
  if (isNetWorking_ && netyic) {
    netyic->signup_login_connect(yijian::buffer::Buffer(type, std::string([data UTF8String])),
                                 [=](uint8_t type, std::string & data, bool * isStop){
                                   callback(type, [NSString stringWithCString:data.c_str() encoding: NSUTF8StringEncoding], isStop);
                                 });
  }else {
    bool isStop;
    callback(255, @"net is not working", &isStop);
  }
}
+ (void)netyi_logout_disconnectWith:(const uint8_t)type data:(NSString * )data cb:(Net_CB)callback {
  if (isNetWorking_ && netyic) {
    netyic->logout_disconnect(yijian::buffer::Buffer(type, std::string([data UTF8String])),
       [=](uint8_t type, std::string & data, bool * isStop){
         callback(type, [NSString stringWithCString:data.c_str() encoding: NSUTF8StringEncoding], isStop);
    });
  }else {
    bool isStop;
    callback(255, @"net is not working", &isStop);
  }
}
+ (int32_t)netyi_sendWith:(const uint8_t)type data:(NSString * )data cb:(Net_CB)callback {
  // 用来查看消息丢失 重发
  if (isNetWorking_ && netyic) {
    int32_t temp_session = 0;
    netyic->send_buffer(yijian::buffer::Buffer(type, std::string([data UTF8String])), &temp_session,
       [=](uint8_t type, std::string & data, bool * isStop){
         callback(type, [NSString stringWithCString:data.c_str() encoding: NSUTF8StringEncoding], isStop);
    });
    return temp_session;
  }else {
    bool isStop;
    callback(255, @"net is not working", &isStop);
    return 0;
  }
}
+ (void)netyi_unread_msg_notiWith:(Net_CB)callback {
  if (isNetWorking_ && netyic) {
    netyic->acceptUnreadMsg(
       [=](uint8_t type, std::string & data, bool * isStop){
         callback(type, [NSString stringWithCString:data.c_str() encoding: NSUTF8StringEncoding], isStop);
    });
  }else {
    bool isStop;
    callback(255, @"net is not working", &isStop);
  }
}
+ (void)netyi_userinfo_notiWith:(Net_CB)callback {
  if (isNetWorking_ && netyic) {
    netyic->userInfoNoti(
       [=](uint8_t type, std::string & data, bool * isStop){
         callback(type, [NSString stringWithCString:data.c_str() encoding: NSUTF8StringEncoding], isStop);
    });
  }else {
    bool isStop;
    callback(255, @"net is not working", &isStop);
  }
}
@end
