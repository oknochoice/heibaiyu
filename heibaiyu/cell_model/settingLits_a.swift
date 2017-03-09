//
//  settingLits_a.swift
//  heibaiyu
//
//  Created by jiwei.wang on 2/8/17.
//  Copyright © 2017 yijian. All rights reserved.
//

import Foundation
import UIKit

public class settingLits_a: settingCell {
  
  @IBOutlet weak var iconImage: UIImageView!
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var subtitleLabel: UILabel!
  
  override var model: settingCellModel? {
    get {
      return super.model
    }
    set (new) {
      super.model = new
      if let new = new {
        titleLabel.text = new.title
        subtitleLabel.text = new.subTitle
        if let icon = new.icon {
          iconImage.sd_setImage(with: URL(string: icon), placeholderImage: #imageLiteral(resourceName: "placeholderimage"))
        }
      }
    }
  }
}
