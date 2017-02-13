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

static netdbwarpper * net_shared= nil;
static netdb_yi * netdb_yi_shared = nil;

@interface netdbwarpper ()
@end

@implementation netdbwarpper

+ (instancetype)sharedNetdb {
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    net_shared = [[netdbwarpper alloc] init];
  });
  return net_shared;
}

- (instancetype)init {
  if (self = [super init]) {
    auto certpath = [[[[NSBundle mainBundle] bundlePath] stringByAppendingFormat:@"/root-ca.crt"] UTF8String];
    auto dbpath = [[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingString:@"/leveldb" ] UTF8String];
    auto phoneModel = [[[UIDevice currentDevice] model] UTF8String];
    auto uuid = [[[[UIDevice currentDevice] identifierForVendor] UUIDString] UTF8String];
    auto osVersion = [[[UIDevice currentDevice] systemVersion] UTF8String];
    auto appVersion = [[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"] UTF8String];
    netdb_yi_shared = new netdb_yi(certpath, dbpath, phoneModel, uuid, osVersion, appVersion);
  }
  return self;
}

- (void)openNet:(Net_CB)callback {
  netdb_yi_shared->openNet([callback](const int err_no, const std::string & err_msg) {
    callback(err_no, [NSString stringWithCString:err_msg.data() encoding:NSUTF8StringEncoding]);
  });
}

- (void)setNetIsReachable:(BOOL)isReachable {
  netdb_yi_shared->netIsReachable(isReachable);
}

- (void)closeNet {
  netdb_yi_shared->closeNet();
}

- (void)registCheck:(NSString *)phoneno :(NSString *)countrycode :(Net_CB)callback {
  netdb_yi_shared->registCheck(std::string([phoneno UTF8String]), std::string([countrycode UTF8String]), [callback](const int err_no, const std::string & err_msg){
    callback(err_no, [NSString stringWithCString:err_msg.data() encoding:NSUTF8StringEncoding]);
  });
}

- (void)regist:(NSString *)phoneno :(NSString *)countrycode :(NSString *)password :(NSString *)verifycode :(Net_CB)callback {
  netdb_yi_shared->regist(std::string([phoneno UTF8String]), std::string([countrycode UTF8String]), std::string([password UTF8String]), std::string([verifycode UTF8String]), [callback](const int err_no, const std::string & err_msg){
    callback(err_no, [NSString stringWithCString:err_msg.data() encoding:NSUTF8StringEncoding]);
  });
}

- (void)login:(NSString *)phoneno :(NSString *)countrycode :(NSString *)password :(Net_CB)callback {
  netdb_yi_shared->login(std::string([phoneno UTF8String]), std::string([countrycode UTF8String]), std::string([password UTF8String]), [callback](const int err_no, const std::string & err_msg){
    callback(err_no, [NSString stringWithCString:err_msg.data() encoding:NSUTF8StringEncoding]);
  });
}

- (void)connect:(NSString *)userid :(Net_CB)callback {
  netdb_yi_shared->connect(std::string([userid UTF8String]), [callback](const int err_no, const std::string & err_msg){
    callback(err_no, [NSString stringWithCString:err_msg.data() encoding:NSUTF8StringEncoding]);
  });
}

/*
 * db
 *
 */

- (NSData *)getCurrentUser {
  try {
    auto user = netdb_yi_shared->db()->getCurrentUser();
    auto string = user.SerializeAsString();
    return [NSData dataWithBytes:string.data() length:string.size()];
  } catch (std::system_error & e) {
    return nil;
  }
}


@end
