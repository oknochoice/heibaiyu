//
//  settingts_a.swift
//  heibaiyu
//
//  Created by jiwei.wang on 2/8/17.
//  Copyright © 2017 yijian. All rights reserved.
//

import Foundation
import UIKit

public class settingts_a: settingCell {
  
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var subtitleLabel: UILabel!
  
  override var model: settingCellModel? {
    get {
      return super.model
    }
    set (new) {
      super.model = model
      titleLabel.text = new?.title
      subtitleLabel.text = new?.subTitle
    }
  }
}
