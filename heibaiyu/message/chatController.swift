//
//  chatController.swift
//  heibaiyu
//
//  Created by jiwei.wang on 3/16/17.
//  Copyright © 2017 yijian. All rights reserved.
//

import Foundation
import Typist
import NextGrowingTextView

class chatController: UIViewController {
  
  class Delegates {
    var addNodeid2Talk: ((String) -> Void)?
  }
  
  var delegates: Delegates = Delegates()
  
  @IBOutlet weak var collectionview: UICollectionView!
  @IBOutlet weak var growingtext: NextGrowingTextView!
  
  @IBOutlet weak var growingviewHeight: NSLayoutConstraint!
  @IBOutlet weak var bottomdis: NSLayoutConstraint!
  @IBOutlet weak var chatlayout: chatLayout!
  fileprivate var isAddCalled: Bool = false
  
  @IBAction func sendMsg(_ sender: UIButton) {
    let text = self.growingtext.text
    self.growingtext.text = ""
    let chatModel = chatCollectionModel()
    chatModel.isIncoming = false
    chatModel.cellIdentifier = "chatCollectionCellMe";
    chatModel.status = chatCollectionModel.Status.prepare
    chatModel.text = text!
    chatModel.msgmodel = self.model
    self.collectionview.performBatchUpdates({ [weak self] in
      if let ss = self {
        ss.items.append(chatModel)
        ss.chatlayout.appendItem(item: chatModel)
        ss.collectionview.insertItems(at: [IndexPath(item: ss.items.count - 1, section: 0)])
      }
    }, completion: { [weak self] (isComplete) in
      if let ss = self {
        if let callback = ss.delegates.addNodeid2Talk {
          if ss.isAddCalled {
          }else {
            callback(ss.model.tonodeid!)
            ss.isAddCalled = true
          }
        }
        ss.collectionview.scrollToItem(at: IndexPath(item: ss.items.count - 1, section: 0), at: .bottom, animated: true)
      }
    })
  }
  var model: messageModel!
  
  let keyboard = Typist.shared
  
  fileprivate var items: [chatCollectionModel] = []
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configKeyboard()
    configGrowingtext()
    loaddatas()
  }
  
  func loaddatas() {
    if let model = model {
      var count: Int = 0
      var incrementid: Int32 = model.maxIncrementID
      let meid = userCurrent.shared()?.id
      while count <= 50 && incrementid >= 1 {
        let data = netdbwarpper.sharedNetdb().dbGet(netdbwarpper.sharedNetdb().dbkeyMessage(model.tonodeid!, String(incrementid)))
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
          chatModel.msgmodel = self.model
          self.items.insert(chatModel, at: 0)
          count += 1
        }
        incrementid -= 1
      }
      self.chatlayout.resetItems(items: self.items)
      self.collectionview.reloadData()
    }
  }
  
  func configKeyboard() {
    keyboard.on(event: .willChangeFrame) { [weak self] (options) in
      blog.verbose(options)
      if let ss = self {
        ss.bottomdis.constant -= (options.endFrame.origin.y - options.startFrame.origin.y)
        UIView.animate(withDuration: options.animationDuration, delay: 0,
                       options: [options.animationCurve.toOptions()], animations: {
          ss.view.layoutIfNeeded()
        }, completion: nil)
      }
    }.start()
    let tap = UITapGestureRecognizer(target: self, action: #selector(resignFirstres))
    self.view.addGestureRecognizer(tap)
  }
  func resignFirstres() {
    let _ = self.growingtext.resignFirstResponder()
  }
  
  func configGrowingtext() {
    self.growingtext.placeholderAttributedText =
      NSAttributedString(string: "type a message",
                         attributes: [NSFontAttributeName: self.growingtext.font!,
                                      NSForegroundColorAttributeName: UIColor.gray])
    self.growingtext.clipsToBounds = true
    self.growingtext.font = UIFont.systemFont(ofSize: 21)
    self.growingtext.delegates.willChangeHeight = { [weak self] (height) in
      if let ss = self {
        let lheight = height > 44 ? height : 44
        ss.growingviewHeight.constant = lheight
        ss.view.layoutIfNeeded()
      }
    }
  }
  
  deinit {
    keyboard.stop()
  }
  
}

extension chatController: UICollectionViewDelegate, UICollectionViewDataSource {
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 1
  }
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return items.count
  }
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let model = items[indexPath.row]
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: model.cellIdentifier, for: indexPath)
    if let cell = cell as? chatCollectionCell {
      let model = cell.setModel(model: model)
      if model.status == chatCollectionModel.Status.prepare {
        model.status = .sending
        model.send()
      }
    }
    return cell
  }
  
}

extension UIViewAnimationCurve {
  func toOptions() -> UIViewAnimationOptions {
    return UIViewAnimationOptions(rawValue: UInt(rawValue << 16))
  }
}

