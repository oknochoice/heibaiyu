//
//  netdbwarpper.hpp
//  heibaiyu
//
//  Created by yijian on 2/11/17.
//  Copyright © 2017 yijian. All rights reserved.
//

#ifndef netdbwarpper_hpp
#define netdbwarpper_hpp

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@interface netdbwarpper : NSObject

typedef void (^Net_CB)(int err_no, const NSString * err_msg);

+ (instancetype)sharedNetdb;
/* net
 */
// init
- (void)openNet:(Net_CB)callback;
- (void)closeNet;
- (void)setNetIsReachable:(BOOL)isReachable;
- (void)messageNoti:(Net_CB)callback;
- (void)userNoti:(Net_CB)login :(Net_CB)addfriend :(Net_CB)addfriendAuthorize;
// login
- (void)registCheck:(NSString*)phoneno :(NSString*)countrycode :(Net_CB)callback;
- (void)regist:(NSString*)phoneno :(NSString*)countrycode :(NSString*)password :(NSString*)verifycode :(Net_CB)callback;
- (void)login:(NSString*)phoneno :(NSString*)countrycode :(NSString*)password :(Net_CB)callback;
- (void)connect:(NSString*)userid :(Net_CB)callback;
- (void)disconnect;
- (void)logout:(Net_CB)callback;
// user property
- (void)setUserRealname:(NSString*)realname :(Net_CB)callback;
- (void)setUserNickname:(NSString*)nickname :(Net_CB)callback;
- (void)setUserIcon:(NSString*)iconpath :(Net_CB)callback;
- (void)setUserDesc:(NSString*)desc :(Net_CB)callback;
- (void)setUserIsmale:(BOOL)isMale :(Net_CB)callback;
- (void)setUserBirthday:(int32_t)birthdayTs :(Net_CB)callback;
// user friend
- (void)addFiend:(NSString*)friendid :(NSString*)msg :(Net_CB)callback;
- (void)addfiendAuthorize:(NSString*)friendid :(BOOL)isAgree :(Net_CB)callback;
- (void)getAddfriendInfo:(Net_CB)callback;
- (void)getUser:(NSString*)userid :(Net_CB)callback;
- (void)getUser:(NSString*)phoneno :(NSString*)countrycode :(Net_CB)callback;
- (void)updateUserAndFriends:(Net_CB)callback;
// message media
- (void)setMediapath:(NSString*)md5 :(NSString*)path :(Net_CB)callback;
- (void)getMediapath:(NSString*)md5 :(Net_CB)callback;
- (void)getNode:(NSString*)nodeid :(Net_CB)callback;
- (void)sendMessage:(NSString*)tonodeid :(NSString*)touserid :(int32_t)type :(NSString*)content :(Net_CB)callback;
- (void)getMessage:(NSString*)tonodeid :(int32_t)fromIncid :(int32_t)toIncid
      :(Net_CB)callback;
/* db
 */

- (nullable NSData*)dbGetCurrentUser;
- (void)dbPutCurrentUser:(NSData*)user;
- (nullable NSString*)dbGetUserid:(NSString*)phoneno :(NSString*)countrycode;
- (nullable NSData*)dbGetUser:(NSString*)userid;
- (nullable NSString*)dbGetMediapath:(NSString*)md5;
- (nullable NSData*)dbGetAddfriends;

- (nullable NSData*)dbGet:(NSString*)key;
- (void)dbPut:(NSData*)data :(NSString*)key;
/*
 * dbkeys
 */
- (NSString*)dbkeyTalklist;
- (NSString*)dbkeyMsgNode:(NSString*)nodeid;
- (NSString*)dbkeyNodeinfo:(NSString*)nodeid;
- (NSString*)dbkeyTalkinfo:(NSString*)nodeid;
- (NSString*)dbkeyMessage:(NSString*)nodeid :(NSString*)incrementid;

@end
NS_ASSUME_NONNULL_END

#endif /* netdbwarpper_hpp */
