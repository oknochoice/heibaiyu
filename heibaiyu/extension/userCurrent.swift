//
//  user.swift
//  heibaiyu
//
//  Created by jiwei.wang on 3/8/17.
//  Copyright © 2017 yijian. All rights reserved.
//

import Foundation

class userCurrent {
  fileprivate static var shared_: Chat_User?
  static func shared() -> Chat_User?{
    if nil != shared_ {
      return shared_
    }else {
      if let data = netdbwarpper.sharedNetdb().dbGetCurrentUser() {
        if let user = try? Chat_User(protobuf: data) {
          shared_ = user
          return shared_
        }else {
          return nil
        }
      }else {
        return nil
      }
    }
  }
}
