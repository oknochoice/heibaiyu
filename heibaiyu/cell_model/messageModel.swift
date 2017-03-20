//
//  messageModel.swift
//  heibaiyu
//
//  Created by jiwei.wang on 3/14/17.
//  Copyright © 2017 yijian. All rights reserved.
//

import Foundation

class messageModel {
  var icon: String?
  var name: String?
  var lastMsg: String?
  
  var tonodeid:String?
  var userid:String?
  var readedIncrementID: Int32 = 0
  var readedIncTs: Int32 = 0
  var maxIncrementID: Int32 = 0
  var maxIncTs: Int32 = 0
  
  static func instance(tonodeid: String) -> messageModel {
    let talkinfo_data = netdbwarpper.sharedNetdb().dbGet(netdbwarpper.sharedNetdb().dbkeyTalkinfo(tonodeid))
    let nodeinfo_data = netdbwarpper.sharedNetdb().dbGet(netdbwarpper.sharedNetdb().dbkeyNodeinfo(tonodeid))
    guard talkinfo_data != nil && nodeinfo_data != nil else {
      let model = messageModel()
      model.tonodeid = tonodeid
      let user = userCurrent.shared()!
      for info in user.friends {
        if info.toNodeId == tonodeid {
          model.userid = info.userId
        }
      }
      return model
    }
    let talkinfo = try! Chat_TalkInfo(protobuf: talkinfo_data!)
    let nodeinfo = try! Chat_NodeInfo(protobuf: nodeinfo_data!)
    let model = messageModel()
    model.maxIncrementID = nodeinfo.maxIncrementId 
    model.tonodeid = talkinfo.toNodeId
    model.readedIncrementID = talkinfo.readedIncrement
    model.userid = talkinfo.toUserId
    model.maxIncTs = nodeinfo.recentTimestamp
    model.readedIncTs = talkinfo.recentTimestamp
    if talkinfo.toUserId != "", let data = netdbwarpper.sharedNetdb().dbGetUser(talkinfo.toUserId),
      let user = try? Chat_User(protobuf: data) {
      model.icon = String.http(relativePath: user.icon)
      model.name = String.getNonNil([user.nickname, user.realname, user.phoneNo])
    }else {
      if let data = netdbwarpper.sharedNetdb().dbGet(netdbwarpper.sharedNetdb().dbkeyMsgNode(talkinfo.toNodeId)),
        let node = try? Chat_MessageNode(protobuf: data) {
        model.name = String.getNonNil([node.nickname, node.id])
      }
    }
    return model
  }
}
