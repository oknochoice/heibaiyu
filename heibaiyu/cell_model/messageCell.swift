//
//  messageCell.swift
//  heibaiyu
//
//  Created by jiwei.wang on 3/14/17.
//  Copyright © 2017 yijian. All rights reserved.
//

import Foundation

class messageCell: UITableViewCell {
  
  @IBOutlet weak var iconimage: UIImageView!
  @IBOutlet weak var statusImage: UIImageView!
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var lastMsgLabel: UILabel!
  @IBOutlet weak var timeLabel: UILabel!
  
  var model_: messageModel?
  var model: messageModel? {
    get {
      return model_
    }
    set (new) {
      model_ = new
    }
  }
  
}
