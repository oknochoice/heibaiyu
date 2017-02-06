//
//  userinfo.swift
//  heibaiyu
//
//  Created by yijian on 2/7/17.
//  Copyright © 2017 yijian. All rights reserved.
//

import Foundation

public class userinfo {
  static func get() -> Chat_ClientConnect? {
    var connect = Chat_ClientConnect()
    if let userid = leveldb.sharedInstance.getCurrentUserid() {
      if let version = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as? String {
        connect.userId = userid
        connect.uuid = UUID().uuidString
        connect.osversion = UIDevice.current.systemVersion
        connect.appVersion = version
        return connect;
      }
    }
    return nil
  }
}
