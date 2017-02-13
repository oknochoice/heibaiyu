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
- (void)openNet:(Net_CB)callback;
- (void)closeNet;
- (void)setNetIsReachable:(BOOL)isReachable;
- (void)registCheck:(NSString*)phoneno :(NSString*)countrycode :(Net_CB)callback;
- (void)regist:(NSString*)phoneno :(NSString*)countrycode :(NSString*)password :(NSString*)verifycode :(Net_CB)callback;
- (void)login:(NSString*)phoneno :(NSString*)countrycode :(NSString*)password :(Net_CB)callback;
- (void)connect:(NSString*)userid :(Net_CB)callback;
/* db
 */
- (nullable NSData*)getCurrentUser;

@end
NS_ASSUME_NONNULL_END

#endif /* netdbwarpper_hpp */
