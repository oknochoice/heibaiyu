//
//  user.swift
//  heibaiyu
//
//  Created by jiwei.wang on 3/8/17.
//  Copyright © 2017 yijian. All rights reserved.
//

import Foundation

public class userCurrent {
  static func shared() -> Chat_User?{
    if let data = netdbwarpper.sharedNetdb().dbGetCurrentUser() {
      if let user = try? Chat_User(protobuf: data) {
        return user
      }else {
        return nil
      }
    }else {
      return nil
    }
  }
  
  static func save(user: Chat_User) {
    if let data = try? user.serializeProtobuf() {
      netdbwarpper.sharedNetdb().dbPutCurrentUser(data)
    }
  }
  
}
