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
  @IBOutlet weak var contentLeft: NSLayoutConstraint!
  @IBOutlet weak var contentRight: NSLayoutConstraint!
  
  var model: chatCollectionModel! {
    didSet {
      if model.isIncoming {
        contentLeft.constant = 5
        contentRight.constant = 60
        self.backgroundColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
      }else {
        contentLeft.constant = 60
        contentRight.constant = 5
        self.backgroundColor = #colorLiteral(red: 0, green: 0.978394568, blue: 0.3484907448, alpha: 1)
      }
      self.layoutIfNeeded()
      contentLabel.text = model.text
    }
  }
  
}
