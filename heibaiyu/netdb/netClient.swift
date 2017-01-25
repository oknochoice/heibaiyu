//
//  netClient.swift
//  heibaiyu
//
//  Created by yijian on 1/25/17.
//  Copyright © 2017 yijian. All rights reserved.
//

import UIKit

class netClient: NSObject {
  static let client_connected = Notification.Name("client_connected");
  func open() {
    var mainpath = Bundle.main.bundlePath
    mainpath.append("/root-ca.crt")
    let cmainpath = (mainpath as NSString).utf8String
    let buffer = UnsafeMutablePointer<Int8>(mutating: cmainpath)
    openyi_net(buffer) { (isSuccess) in
      NotificationCenter.default.post(name: netClient.client_connected, object: nil, userInfo: ["connected": true])
    }
  }
  

}
