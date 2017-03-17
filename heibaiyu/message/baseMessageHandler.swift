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
    blog.verbose()
    //self.messageSender.sendMessage(viewModel.messageModel)
  }

  func userDidTapOnAvatar(viewModel: MessageViewModelProtocol) {
    blog.verbose()
  }

  func userDidTapOnBubble(viewModel: msgViewModelProtocol) {
    blog.verbose()
  }

  func userDidBeginLongPressOnBubble(viewModel: msgViewModelProtocol) {
    blog.verbose()
  }

  func userDidEndLongPressOnBubble(viewModel: msgViewModelProtocol) {
    blog.verbose()
  }
}
