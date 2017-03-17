//
//  textMsgModel.swift
//  heibaiyu
//
//  Created by jiwei.wang on 3/16/17.
//  Copyright © 2017 yijian. All rights reserved.
//

import Foundation
import Chatto
import ChattoAdditions

public class textMsgModel:  TextMessageModel<MessageModel> {
  public override init(messageModel: MessageModel, text: String) {
    super.init(messageModel: messageModel, text: text)
  }
  
  public var status: MessageStatus {
    get {
      return self._messageModel.status
    }
    set {
      self._messageModel.status = newValue
    }
  }
}

extension TextMessageModel {
  static var chatItemType: ChatItemType {
    return "text"
  }
}
