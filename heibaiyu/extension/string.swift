//
//  string.swift
//  heibaiyu
//
//  Created by jiwei.wang on 2/27/17.
//  Copyright © 2017 yijian. All rights reserved.
//

import Foundation

public extension String {
  static func http(relativePath: String) -> String {
    return "http://oknochoice-file.b0.upaiyun.com" + relativePath
  }
  static func getNonNil(_ values: [String?]) -> String{
    for str in values {
      if nil != str && str != "" {
        return str!
      }
    }
    return ""
  }
  func transformToPinYin() -> String {
    
    let mutableString = NSMutableString(string: self)
    //把汉字转为拼音
    CFStringTransform(mutableString, nil, kCFStringTransformToLatin, false)
    //去掉拼音的音标
    CFStringTransform(mutableString, nil, kCFStringTransformStripDiacritics, false)
    let string = String(mutableString)
    //去掉空格
    return string.replacingOccurrences(of: " ", with: "")
    
  }
}
