//
//  friendCell.swift
//  heibaiyu
//
//  Created by jiwei.wang on 3/14/17.
//  Copyright © 2017 yijian. All rights reserved.
//

import Foundation

class friendCell: settingCell {
  
  @IBOutlet weak var iconimage: UIImageView!
  @IBOutlet weak var titleL: UILabel!
  @IBOutlet weak var subtitleL: UILabel!
  
  override var model: settingCellModel? {
    get {
      return super.model
    }
    set (new) {
      super.model = new
      if let icon = new?.icon {
        iconimage.sd_setImage(with: URL(string: icon), placeholderImage: #imageLiteral(resourceName: "placeholderimage"))
      }else if let image = new?.iconImage {
        iconimage.image = image
      }
      titleL.text = model?.title
      subtitleL.text = model?.subTitle
    }
  }
  
}
