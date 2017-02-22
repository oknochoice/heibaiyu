//
//  netdbwarpper.cpp
//  heibaiyu
//
//  Created by yijian on 2/11/17.
//  Copyright © 2017 yijian. All rights reserved.
//

#include "netdbwarpper.hpp"
#include "netdb_yi.hpp"
#include "leveldb_yi.hpp"
#include <google/chat_message.pb.h>

static netdbwarpper * net_shared_ = nil;
static netdb_yi * netdb_yi_shared_ = nil;
static leveldb_yi * db_ = nil;

@interface netdbwarpper ()
@end

@implementation netdbwarpper

+ (instancetype)sharedNetdb {
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    net_shared_ = [[netdbwarpper alloc] init];
  });
  return net_shared_;
}

- (instancetype)init {
  if (self = [super init]) {
    auto certpath = [[[[NSBundle mainBundle] bundlePath] stringByAppendingFormat:@"/root-ca.crt"] UTF8String];
    auto dbpath = [[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingString:@"/leveldb" ] UTF8String];
    auto phoneModel = [[[UIDevice currentDevice] model] UTF8String];
    auto uuid = [[[[UIDevice currentDevice] identifierForVendor] UUIDString] UTF8String];
    auto osVersion = [[[UIDevice currentDevice] systemVersion] UTF8String];
    auto appVersion = [[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"] UTF8String];
    netdb_yi_shared_ = new netdb_yi(certpath, dbpath, phoneModel, uuid, osVersion, appVersion);
    db_ = netdb_yi_shared_->db();
  }
  return self;
}

- (void)openNet:(Net_CB)callback {
  netdb_yi_shared_->openNet([callback](const int err_no, const std::string & err_msg) {
    callback(err_no, [NSString stringWithCString:err_msg.data() encoding:NSUTF8StringEncoding]);
  }, nullptr);
}

- (void)setNetIsReachable:(BOOL)isReachable {
  netdb_yi_shared_->netIsReachable(isReachable);
}

- (void)closeNet {
  netdb_yi_shared_->closeNet();
}

- (void)registCheck:(NSString *)phoneno :(NSString *)countrycode :(Net_CB)callback {
  netdb_yi_shared_->registCheck(std::string([phoneno UTF8String]), std::string([countrycode UTF8String]), [callback](const int err_no, const std::string & err_msg){
    callback(err_no, [NSString stringWithCString:err_msg.data() encoding:NSUTF8StringEncoding]);
  });
}

- (void)regist:(NSString *)phoneno :(NSString *)countrycode :(NSString *)password :(NSString *)verifycode :(Net_CB)callback {
  netdb_yi_shared_->regist(std::string([phoneno UTF8String]), std::string([countrycode UTF8String]), std::string([password UTF8String]), std::string([verifycode UTF8String]), [callback](const int err_no, const std::string & err_msg){
    callback(err_no, [NSString stringWithCString:err_msg.data() encoding:NSUTF8StringEncoding]);
  });
}

- (void)login:(NSString *)phoneno :(NSString *)countrycode :(NSString *)password :(Net_CB)callback {
  netdb_yi_shared_->login(std::string([phoneno UTF8String]), std::string([countrycode UTF8String]), std::string([password UTF8String]), [callback](const int err_no, const std::string & err_msg){
    callback(err_no, [NSString stringWithCString:err_msg.data() encoding:NSUTF8StringEncoding]);
  });
}

- (void)connect:(NSString *)userid :(Net_CB)callback {
  netdb_yi_shared_->connect(std::string([userid UTF8String]), [callback](const int err_no, const std::string & err_msg){
    callback(err_no, [NSString stringWithCString:err_msg.data() encoding:NSUTF8StringEncoding]);
  });
}
- (void)disconnect {
  netdb_yi_shared_->disconnect([](const int err_no, const std::string & err_msg){
    //callback(err_no, [NSString stringWithCString:err_msg.data() encoding:NSUTF8StringEncoding]);
  });
  
}
- (void)logout:(Net_CB)callback {
  netdb_yi_shared_->logout([callback](const int err_no, const std::string & err_msg){
    callback(err_no, [NSString stringWithCString:err_msg.data() encoding:NSUTF8StringEncoding]);
  });
}

- (void)setUserRealname:(NSString*)realname :(Net_CB)callback {
  netdb_yi_shared_->userSetRealname(std::string([realname UTF8String]), [callback](const int err_no, const std::string & err_msg){
    callback(err_no, [NSString stringWithCString:err_msg.data() encoding:NSUTF8StringEncoding]);
  });
}
- (void)setUserNickname:(NSString*)nickname :(Net_CB)callback {
  netdb_yi_shared_->userSetNickname(std::string([nickname UTF8String]), [callback](const int err_no, const std::string & err_msg){
    callback(err_no, [NSString stringWithCString:err_msg.data() encoding:NSUTF8StringEncoding]);
  });
  
}
- (void)setUserIcon:(NSString*)iconpath :(Net_CB)callback {
  netdb_yi_shared_->userSetIcon(std::string([iconpath UTF8String]), [callback](const int err_no, const std::string & err_msg){
    callback(err_no, [NSString stringWithCString:err_msg.data() encoding:NSUTF8StringEncoding]);
  });
  
}
- (void)setUserDesc:(NSString*)desc :(Net_CB)callback {
  netdb_yi_shared_->userSetDescription(std::string([desc UTF8String]), [callback](const int err_no, const std::string & err_msg){
    callback(err_no, [NSString stringWithCString:err_msg.data() encoding:NSUTF8StringEncoding]);
  });
  
}
- (void)setUserIsmale:(BOOL)isMale :(Net_CB)callback {
  netdb_yi_shared_->userSetIsmale(isMale, [callback](const int err_no, const std::string & err_msg){
    callback(err_no, [NSString stringWithCString:err_msg.data() encoding:NSUTF8StringEncoding]);
  });
  
}
- (void)setUserBirthday:(int32_t)birthdayTs :(Net_CB)callback {
  netdb_yi_shared_->userSetBirthday(birthdayTs, [callback](const int err_no, const std::string & err_msg){
    callback(err_no, [NSString stringWithCString:err_msg.data() encoding:NSUTF8StringEncoding]);
  });
  
}

// user friend
- (void)addFiend:(NSString*)friendid :(NSString*)msg :(Net_CB)callback {
  netdb_yi_shared_->addFriend(std::string([friendid UTF8String]), std::string([msg UTF8String]), [callback](const int err_no, const std::string & err_msg){
    callback(err_no, [NSString stringWithCString:err_msg.data() encoding:NSUTF8StringEncoding]);
  });
}
- (void)addfiendAuthorize:(NSString*)friendid :(BOOL)isAgree :(Net_CB)callback {
  netdb_yi_shared_->addFriendAuthorize(std::string([friendid UTF8String]), isAgree, [callback](const int err_no, const std::string & err_msg){
    callback(err_no, [NSString stringWithCString:err_msg.data() encoding:NSUTF8StringEncoding]);
  });
}
- (void)getAddfriendInfo:(Net_CB)callback {
  netdb_yi_shared_->getAddfriendInfo([callback](const int err_no, const std::string & err_msg){
    callback(err_no, [NSString stringWithCString:err_msg.data() encoding:NSUTF8StringEncoding]);
  });
}
- (void)getUser:(NSString*)userid :(Net_CB)callback {
  netdb_yi_shared_->getUser(std::string([userid UTF8String]), [callback](const int err_no, const std::string & err_msg){
    callback(err_no, [NSString stringWithCString:err_msg.data() encoding:NSUTF8StringEncoding]);
  });
}
- (void)getUser:(NSString*)phoneno :(NSString*)countrycode :(Net_CB)callback {
  netdb_yi_shared_->getUser(std::string([phoneno UTF8String]), std::string([countrycode UTF8String]), [callback](const int err_no, const std::string & err_msg){
    callback(err_no, [NSString stringWithCString:err_msg.data() encoding:NSUTF8StringEncoding]);
  });
}
- (void)setMediapath:(NSString*)md5 :(NSString*)path :(Net_CB)callback {
  netdb_yi_shared_->setMediaPath(std::string([md5 UTF8String]), std::string([path UTF8String]), [callback](const int err_no, const std::string & err_msg){
    callback(err_no, [NSString stringWithCString:err_msg.data() encoding:NSUTF8StringEncoding]);
  });
}
- (void)getMediapath:(NSString*)md5 :(Net_CB)callback {
  netdb_yi_shared_->getMediaPath(std::string([md5 UTF8String]), [callback](const int err_no, const std::string & err_msg){
    callback(err_no, [NSString stringWithCString:err_msg.data() encoding:NSUTF8StringEncoding]);
  });
}
- (void)getNode:(NSString*)nodeid :(Net_CB)callback {
  netdb_yi_shared_->getNode(std::string([nodeid UTF8String]), [callback](const int err_no, const std::string & err_msg){
    callback(err_no, [NSString stringWithCString:err_msg.data() encoding:NSUTF8StringEncoding]);
  });
}
- (void)sendMessage:(NSString*)tonodeid :(int32_t)type :(NSString*)content :(Net_CB)callback {
  netdb_yi_shared_->sendMessage(std::string([tonodeid UTF8String]), type, std::string([content UTF8String]), [callback](const int err_no, const std::string & err_msg){
    callback(err_no, [NSString stringWithCString:err_msg.data() encoding:NSUTF8StringEncoding]);
  });
}
- (void)getMessage:(NSString*)tonodeid :(int32_t)fromIncid :(int32_t)toIncid
                  :(Net_CB)callback {
  netdb_yi_shared_->getMessage(std::string([tonodeid UTF8String]), fromIncid, toIncid, [callback](const int err_no, const std::string & err_msg){
    callback(err_no, [NSString stringWithCString:err_msg.data() encoding:NSUTF8StringEncoding]);
  });
}
/*
 * db
 *
 */

- (nullable NSData *)getCurrentUser {
  try {
    auto string = db_->get(db_->userKey(db_->getCurrentUserid()));
    return [NSData dataWithBytes:string.data() length:string.size()];
  } catch (std::system_error & e) {
    return nil;
  }
}


- (nullable NSString*)getMediapath:(NSString*)md5 {
  try {
    auto path = db_->getMediaPath(std::string([md5 UTF8String]));
    return [NSString stringWithCString:path.data() encoding:NSUTF8StringEncoding];
  } catch (...) {
    return nil;
  }
}

@end
