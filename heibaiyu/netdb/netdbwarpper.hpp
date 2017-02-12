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

typedef void (^Net_CB)(int err_no, NSString * err_msg);

+ (instancetype)sharedNetdb();

@end
NS_ASSUME_NONNULL_END

#endif /* netdbwarpper_hpp */
