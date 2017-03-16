//
//  chatController.swift
//  heibaiyu
//
//  Created by jiwei.wang on 3/16/17.
//  Copyright © 2017 yijian. All rights reserved.
//

import Foundation
import Chatto
import ChattoAdditions

class chatController: BaseChatViewController {
  
  var dataSource: chatItemDataSource! {
    didSet {
      self.chatDataSource = self.dataSource
      self.chatDataSourceDidUpdate(self.dataSource)
    }
  }

  // chat message prensenter
  /*
  override func createPresenterBuilders() -> [ChatItemType : [ChatItemPresenterBuilderProtocol]] {
    let textMessagePresenter = TextMessagePresenterBuilder(viewModelBuilder: <#T##ViewModelBuilderT#>, interactionHandler: <#T##InteractionHandlerT?#>)
  }
 */
  
//  chat input presenter
  var chatInputPresenter: BasicChatInputBarPresenter!
  override func createChatInputView() -> UIView {
    let chatInputView = ChatInputBar.loadNib()
    var appearance = ChatInputBarAppearance()
    appearance.sendButtonAppearance.title = L10n.messageChatInputSend
    appearance.textInputAppearance.placeholderText = L10n.messageChatInputPlaceholdertext
    self.chatInputPresenter = BasicChatInputBarPresenter(chatInputBar: chatInputView, chatInputItems: self.createChatInputItems(), chatInputBarAppearance: appearance)
    chatInputView.maxCharactersCount = 1000
    return chatInputView
  }
  func createChatInputItems() -> [ChatInputItemProtocol] {
    var items = [ChatInputItemProtocol]()
    items.append(self.createTextInputItem())
    items.append(self.createPhotoInputItem())
    return items
  }
  private func createTextInputItem() -> TextChatInputItem {
    let item = TextChatInputItem()
    item.textInputHandler = { [weak self] text in
      self?.dataSource.addTextMessage(text)
    }
    return item
  }

  private func createPhotoInputItem() -> PhotosChatInputItem {
    let item = PhotosChatInputItem(presentingController: self)
    item.photoInputHandler = { [weak self] image in
      self?.dataSource.addPhotoMessage(image)
    }
    return item
  }
}

