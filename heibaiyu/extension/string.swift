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
}
