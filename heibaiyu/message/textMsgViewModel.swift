//
//  textMsgViewModel.swift
//  heibaiyu
//
//  Created by jiwei.wang on 3/16/17.
//  Copyright © 2017 yijian. All rights reserved.
//

import Foundation
import Chatto
import ChattoAdditions

public class textMsgViewModel: TextMessageViewModel<textMsgModel>,
  msgViewModelProtocol {
  public override init(textMessage: textMsgModel, messageViewModel: MessageViewModelProtocol) {
    super.init(textMessage: textMessage, messageViewModel: messageViewModel)
  }
  
  public var msgModel: msgModelProtocol {
    return self.msgModel
  }
  
}

public class textMsgViewModelBuilder: ViewModelBuilderProtocol {
  
  public init() {}
  
  let messageViewModelBuilder = MessageViewModelDefaultBuilder()

  public func createViewModel(_ textMessage: textMsgModel) -> textMsgViewModel {
      let messageViewModel = self.messageViewModelBuilder.createMessageViewModel(textMessage)
      let textMessageViewModel = textMsgViewModel(textMessage: textMessage, messageViewModel: messageViewModel)
      textMessageViewModel.avatarImage.value = UIImage(named: "userAvatar")
      return textMessageViewModel
  }

  public func canCreateViewModel(fromModel model: Any) -> Bool {
      return model is textMsgModel
  }
}

