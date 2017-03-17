//
//  chatDataSource.swift
//  heibaiyu
//
//  Created by jiwei.wang on 3/16/17.
//  Copyright © 2017 yijian. All rights reserved.
//

import Foundation
import Chatto
import ChattoAdditions

class chatItemDataSource: ChatDataSourceProtocol {
  
  init(node: messageModel) {
    
  }
  
  // MARK - chat data source protocol
  var hasMoreNext: Bool {
    return true
  }
  var hasMorePrevious: Bool {
    return true
  }
  fileprivate var chatdatas: [ChatItemProtocol] = []
  var chatItems: [ChatItemProtocol] {
    return chatdatas
  }
  var delegate: ChatDataSourceDelegateProtocol?
  func loadNext() {
  }
  func loadPrevious() {
  }
  func adjustNumberOfMessages(preferredMaxCount: Int?, focusPosition: Double, completion: ((Bool)) -> Void) {
  }
  
  
  // add message
  var nextMessageId: Int = 0
  func addTextMessage(_ text: String) {
    let uid = "\(self.nextMessageId)"
    self.nextMessageId += 1
    let msgmodel = createMessageModel(uid, isIncoming: false, type: TextMessageModel<MessageModel>.chatItemType)
    let textMsg = textMsgModel(messageModel: msgmodel, text: text)
    chatdatas.append(textMsg)
    self.delegate?.chatDataSourceDidUpdate(self)
  }
  func createMessageModel(_ uid: String, isIncoming: Bool, type: String) -> MessageModel {
    let senderId = isIncoming ? "1" : "2"
    let messageStatus = isIncoming ? MessageStatus.success : .sending
    let messageModel = MessageModel(uid: uid, senderId: senderId, type: type, isIncoming: isIncoming, date: Date(), status: messageStatus)
    return messageModel
  }
}
