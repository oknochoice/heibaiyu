//
//  textMsgHandler.swift
//  heibaiyu
//
//  Created by jiwei.wang on 3/16/17.
//  Copyright © 2017 yijian. All rights reserved.
//

import Foundation
import ChattoAdditions

class textMsgHandler: BaseMessageInteractionHandlerProtocol {
  
  private let baseHandler: baseMessageHandler
  init(baseHandler: baseMessageHandler) {
    self.baseHandler = baseHandler
  }
  
  func userDidTapOnFailIcon(viewModel: textMsgViewModel, failIconView: UIView) {
    self.baseHandler.userDidTapOnFailIcon(viewModel: viewModel)
  }

  func userDidTapOnAvatar(viewModel: textMsgViewModel) {
    self.baseHandler.userDidTapOnAvatar(viewModel: viewModel)
  }

  func userDidTapOnBubble(viewModel: textMsgViewModel) {
    self.baseHandler.userDidTapOnBubble(viewModel: viewModel)
  }

  func userDidBeginLongPressOnBubble(viewModel: textMsgViewModel) {
    self.baseHandler.userDidBeginLongPressOnBubble(viewModel: viewModel)
  }

  func userDidEndLongPressOnBubble(viewModel: textMsgViewModel) {
    self.baseHandler.userDidEndLongPressOnBubble(viewModel: viewModel)
  }
}
