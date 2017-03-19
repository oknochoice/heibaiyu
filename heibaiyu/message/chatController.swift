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
  
  @IBOutlet weak var collectionview: UICollectionView!
  @IBOutlet weak var growingtext: NextGrowingTextView!
  
  @IBOutlet weak var growingviewHeight: NSLayoutConstraint!
  @IBOutlet weak var bottomdis: NSLayoutConstraint!
  
  @IBAction func sendMsg(_ sender: UIButton) {
    let text = self.growingtext.text
    self.growingtext.text = ""
    let chatModel = chatCollectionModel()
    chatModel.isIncoming = false
    chatModel.status = chatCollectionModel.Status.sending
    chatModel.text = text!
    self.items.append(chatModel)
    self.collectionview.insertItems(at: [IndexPath(item: self.items.count - 1, section: 0)])
  }
  var model: messageModel?
  
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
      while count >= 50 || incrementid <= 1 {
        let data = netdbwarpper.sharedNetdb().dbGet(netdbwarpper.sharedNetdb().dbkeyMessage(model.tonodeid!, String(incrementid)))
        if let data = data {
          let msg = try! Chat_NodeMessage(protobuf: data)
          let chatModle = chatCollectionModel()
          chatModle.status = chatCollectionModel.Status.success
          chatModle.isIncoming = msg.fromUserId == meid ? false : true
          chatModle.text = msg.content
          self.items.append(chatModle)
        }
        count += 1
        incrementid -= 1
      }
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
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "chatCollectionCell", for: indexPath)
    if let cell = cell as? chatCollectionCell {
      cell.model = model
    }
    return cell
  }
  
}

extension UIViewAnimationCurve {
  func toOptions() -> UIViewAnimationOptions {
    return UIViewAnimationOptions(rawValue: UInt(rawValue << 16))
  }
}

