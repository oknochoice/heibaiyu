//
//  leveldbwarpper.hpp
//  heibaiyu
//
//  Created by yijian on 2/5/17.
//  Copyright © 2017 yijian. All rights reserved.
//

#ifndef leveldbwarpper_h
#define leveldbwarpper_h

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN
@interface leveldbwarpper : NSObject

+ (BOOL)open_dbWith:(NSString*)path;
+ (void)close_db;
+ (BOOL)db_putWith:(NSString*)key Data:(NSString*)data;
+ (nullable NSString*)db_getWith:(NSString*)key;
+ (BOOL)db_deleteWith:(NSString*)key;

@end
NS_ASSUME_NONNULL_END
#endif /* leveldbwarpper_hpp */
