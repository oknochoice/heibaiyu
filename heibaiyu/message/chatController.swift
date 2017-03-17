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
  
  var node: messageModel!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.dataSource = chatItemDataSource(node: node)
  }
  
  var dataSource: chatItemDataSource! {
    didSet {
      self.chatDataSource = self.dataSource
      self.chatDataSourceDidUpdate(self.dataSource)
    }
  }
  
  var msgSender: msgSender!
  lazy private var baseMsgHandler: baseMessageHandler = {
    return baseMessageHandler(msgSender: self.msgSender)
  }()

  // chat message prensenter
  override func createPresenterBuilders() -> [ChatItemType : [ChatItemPresenterBuilderProtocol]] {
    let textMessagePresenter = TextMessagePresenterBuilder(viewModelBuilder: textMsgViewModelBuilder(), interactionHandler: textMsgHandler(baseHandler: self.baseMsgHandler))
    textMessagePresenter.baseMessageStyle = BaseMessageCollectionViewCellDefaultStyle()
    
    return [
      textMsgModel.chatItemType: [
        textMessagePresenter
      ]
    ]
  }
  
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
    return items
  }
  private func createTextInputItem() -> TextChatInputItem {
    let item = TextChatInputItem()
    item.textInputHandler = { [weak self] text in
      self?.dataSource.addTextMessage(text)
    }
    return item
  }

  /*
  private func createPhotoInputItem() -> PhotosChatInputItem {
    let item = PhotosChatInputItem(presentingController: self)
    item.photoInputHandler = { [weak self] image in
      self?.dataSource.addPhotoMessage(image)
    }
    return item
  }
 */
}

