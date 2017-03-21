//
//  chatCollectionModel.swift
//  heibaiyu
//
//  Created by yijian on 3/19/17.
//  Copyright © 2017 yijian. All rights reserved.
//

import Foundation

class chatCollectionModel {
  
  class Delegates {
    var sendMsgCallback: ((Int32, String) -> Void)?
  }
  var delegates: Delegates = Delegates()
  
  enum Status {
    case success,
    failure,
    sending,
    prepare
  }
  
  var msgmodel: messageModel!
  var incrementid: Int32 = 0
  var cellIdentifier: String = ""
  var isIncoming: Bool = true
  var status: Status = .success
  var text: String = "no content"
  
  func clearDelegates() {
    delegates.sendMsgCallback = nil
  }
  
  func send() {
    netdbwarpper.sharedNetdb().sendMessage(
      msgmodel.tonodeid ?? "",
      msgmodel.userid ?? "",
      Int32(Chat_MediaType.text.rawValue),
      text) { [weak self] (errno, errmsg) in
        DispatchQueue.main.async {
          if let ss = self, let callback = ss.delegates.sendMsgCallback {
            if 0 == errno {
              ss.status = .success
              ss.incrementid = Int32(errmsg)!
            }else {
              ss.status = .failure
            }
            callback(errno, errmsg)
          }
        }
    }
  }
  
  static func instance(meid: String, tonodeid: String, incrementid: Int32) -> chatCollectionModel? {
    
    let data = netdbwarpper.sharedNetdb().dbGet(
      netdbwarpper.sharedNetdb().dbkeyMessage(
        tonodeid, String(incrementid)))
    if let data = data {
      let msg = try! Chat_NodeMessage(protobuf: data)
      let chatModel = chatCollectionModel()
      chatModel.status = chatCollectionModel.Status.success
      chatModel.isIncoming = msg.fromUserId == meid ? false : true
      if chatModel.isIncoming {
        chatModel.cellIdentifier = "chatCollectionCellIncoming";
      }else {
        chatModel.cellIdentifier = "chatCollectionCellMe";
      }
      chatModel.text = msg.content
      chatModel.incrementid = incrementid
      return chatModel
    }else {
      return nil
    }
    
  }
}
