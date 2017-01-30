//
//  NSBundle+language.m
//  heibaiyu
//
//  Created by yijian on 1/30/17.
//  Copyright © 2017 yijian. All rights reserved.
//

#import "NSBundle+language.h"
#import <objc/runtime.h>

static const char _associatedLanguageBundle = '\0';
static const char _language = '\0';

@interface PrivateBundle : NSBundle
@end

@implementation PrivateBundle
-(NSString*)localizedStringForKey:(NSString *)key
                            value:(NSString *)value
                            table:(NSString *)tableName
{
  NSBundle* bundle=objc_getAssociatedObject(self, &_associatedLanguageBundle);
  return bundle ? [bundle localizedStringForKey:key
                                          value:value
                                          table:tableName] : [super localizedStringForKey:key
                                                                                    value:value
                                                                                    table:tableName];
}
@end

@implementation NSBundle (language)




+(void)setLanguage:(NSString*)language
{
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^
                {
                object_setClass([NSBundle mainBundle],[PrivateBundle class]);
                });
  objc_setAssociatedObject([NSBundle mainBundle], &_associatedLanguageBundle, language ? [NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:language ofType:@"lproj"]] : nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
  
  objc_setAssociatedObject(self, &_language, language, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

+ (NSString*)getLanguage{
  return objc_getAssociatedObject(self, &_language);
}

@end
