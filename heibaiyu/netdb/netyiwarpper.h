//
//  netyiwarpper.h
//  heibaiyu
//
//  Created by jiwei.wang on 1/25/17.
//  Copyright © 2017 yijian. All rights reserved.
//

#ifndef netyiwarpper_h
#define netyiwarpper_h

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@interface netyiwarpper : NSObject

typedef void (^Net_CB)(int16_t type, NSData * data,  bool * _Nullable  isStop);

typedef void (^Net_Connect_CB)(int err_no, NSString * err_msg);
+ (void)openyi_netWithcert:(NSString *)certpath with:(NSData*)ping with:(Net_Connect_CB)isSuccess;
+ (BOOL)netyi_isOpened;
+ (void)netyi_net_isConnect:(BOOL)isConnect;
+ (void)closeyi_net;
+ (void)netyi_signup_login_connectWith:(const uint8_t)type data:(NSData * )data cb:(Net_CB)callback;
+ (void)netyi_logout_disconnectWith:(const uint8_t)type data:(NSData * )data cb:(Net_CB)callback;
// return session id ,
// identity message
+ (int32_t)netyi_sendWith:(const uint8_t)type data:(NSData * )data cb:(Net_CB)callback;
+ (void)netyi_unread_msg_notiWith:(Net_CB)callback;
+ (void)netyi_userinfo_notiWith:(Net_CB)callback;

@end
NS_ASSUME_NONNULL_END

  
#endif /* netyiwarpper_h */
