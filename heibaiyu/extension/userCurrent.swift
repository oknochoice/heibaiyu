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
  fileprivate static var talklist_ = NSMutableOrderedSet()
  static func getTalklist() -> [String] {
    let talklist_data = netdbwarpper.sharedNetdb().dbGet(netdbwarpper.sharedNetdb().dbkeyTalklist())
    if let data = talklist_data, let talklist = try? Chat_TalkList(protobuf: data) {
      for obj in talklist.talkNodeIds {
        talklist_.add(obj)
      }
    }
    return talklist_.array as! [String]
  }
  
  fileprivate static func addTalknodeid(nodeid: String) {
    talklist_.add(nodeid)
    saveTalklist()
  }
  
  fileprivate static func saveTalklist() {
    var talklist = Chat_TalkList()
    for obj in talklist_ {
      let nodeid = obj as! String
      talklist.talkNodeIds.append(nodeid)
    }
    netdbwarpper.sharedNetdb().dbPut(try! talklist.serializeProtobuf(), netdbwarpper.sharedNetdb().dbkeyTalklist())
  }
  
  static func putTalkinfo(info: Chat_TalkInfo) {
    if let data = try? info.serializeProtobuf() {
      addTalknodeid(nodeid: info.toNodeId)
      netdbwarpper.sharedNetdb().dbPut(data, netdbwarpper.sharedNetdb().dbkeyTalkinfo(info.toNodeId))
    }
  }
  
}
