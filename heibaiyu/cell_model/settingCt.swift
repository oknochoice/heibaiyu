//
//  settingCt.swift
//  heibaiyu
//
//  Created by jiwei.wang on 2/8/17.
//  Copyright © 2017 yijian. All rights reserved.
//

import Foundation
import UIKit

class settingCt: settingCell {
  @IBOutlet weak var titleLabel: UILabel!
  
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
