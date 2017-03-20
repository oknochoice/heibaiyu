//
//  chatCollectionCell.swift
//  heibaiyu
//
//  Created by yijian on 3/19/17.
//  Copyright © 2017 yijian. All rights reserved.
//

import Foundation

class chatCollectionCell: UICollectionViewCell {
  
  @IBOutlet weak var contentLabel: UILabel!
  
  fileprivate var model: chatCollectionModel! {
    didSet {
      if model.isIncoming {
        self.backgroundColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
      }else {
        if model.status == chatCollectionModel.Status.sending ||
          model.status == .prepare{
          self.backgroundColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
        }else if model.status == chatCollectionModel.Status.success  {
          self.backgroundColor = #colorLiteral(red: 0, green: 0.978394568, blue: 0.3484907448, alpha: 1)
        }else {
          self.backgroundColor = #colorLiteral(red: 0.9877519011, green: 0.3219017982, blue: 0.2846495807, alpha: 1)
        }
      }
      model.delegates.sendMsgCallback = { [weak self] (errno, errmsg) in
        if let ss = self {
          if 0 == errno {
            ss.backgroundColor = #colorLiteral(red: 0, green: 0.978394568, blue: 0.3484907448, alpha: 1)
            NotificationCenter.default.post(name: notificationName.updateOneMsg, object: ss, userInfo: [notificationName.updateOneMsg_key_nodeid: ss.model.msgmodel.tonodeid!])
          }else {
            ss.backgroundColor = #colorLiteral(red: 0.9877519011, green: 0.3219017982, blue: 0.2846495807, alpha: 1)
          }
        }
      }
      self.layoutIfNeeded()
      contentLabel.text = model.text
    }
  }
  
  func setModel(model: chatCollectionModel) -> chatCollectionModel {
    self.model = model
    return self.model
  }
  
  override func prepareForReuse() {
    self.model.clearDelegates()
  }
  
}
