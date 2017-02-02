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

typedef void (^Net_CB)(uint8_t type, NSString * data, bool * isStop);

typedef void (^IsConnectSuccess)();
  
+ (BOOL)openyi_netWithcert:(NSString *)certpath with:(IsConnectSuccess)isSuccess;
+ (long)netyi_ts;
+ (void)netyi_ping:(NSString*)data;
+ (BOOL)closeyi_net;
+ (BOOL)netyi_signup_login_connectWith:(const uint8_t)type data:(NSString * )data cb:(Net_CB)callback;
+ (BOOL)netyi_logout_disconnectWith:(const uint8_t)type data:(NSString * )data cb:(Net_CB)callback;
+ (BOOL)netyi_sendWith:(const uint8_t)type data:(NSString * )data cb:(Net_CB)callback;
+ (BOOL)netyi_unread_msg_notiWith:(Net_CB)callback;
+ (BOOL)netyi_userinfo_notiWith:(Net_CB)callback;

@end
NS_ASSUME_NONNULL_END

  
#endif /* netyiwarpper_h */
