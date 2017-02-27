//
//  settingRit_a.swift
//  heibaiyu
//
//  Created by jiwei.wang on 2/8/17.
//  Copyright © 2017 yijian. All rights reserved.
//

import Foundation
import SDWebImage
import UIKit

class settingRit_a: settingCell {
  @IBOutlet weak var iconImage: UIImageView!
  @IBOutlet weak var titleLabel: UILabel!
  override var icon: String? {
    get {
      return super.icon
    }
    set(newIcon) {
      super.icon = newIcon
      if let icon = newIcon {
        iconImage.sd_setImage(with: URL(string: icon), placeholderImage: #imageLiteral(resourceName: "placeholderimage"))
      }
    }
  }
  
  override var title: String? {
    get {
      return super.title;
    }
    set(newTitle) {
      super.title = newTitle
      titleLabel.text = title
    }
  }
  
}
