//
//  baseMessageHandler.swift
//  heibaiyu
//
//  Created by yijian on 3/16/17.
//  Copyright © 2017 yijian. All rights reserved.
//

import Foundation
import Chatto
import ChattoAdditions

public protocol msgViewModelProtocol {
  var msgModel: msgModelProtocol { get }
}

class baseMessageHandler {
  private let msgSender: msgSender
  
  init (msgSender: msgSender) {
    self.msgSender = msgSender
  }
  
  
  func userDidTapOnFailIcon(viewModel: msgViewModelProtocol) {
    //self.messageSender.sendMessage(viewModel.messageModel)
  }

  func userDidTapOnAvatar(viewModel: MessageViewModelProtocol) {
  }

  func userDidTapOnBubble(viewModel: msgViewModelProtocol) {
  }

  func userDidBeginLongPressOnBubble(viewModel: msgViewModelProtocol) {
  }

  func userDidEndLongPressOnBubble(viewModel: msgViewModelProtocol) {
  }
}
