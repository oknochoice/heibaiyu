//
//  settingts.swift
//  heibaiyu
//
//  Created by jiwei.wang on 2/8/17.
//  Copyright © 2017 yijian. All rights reserved.
//

import Foundation
import UIKit

class settingts: settingCell {
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var subtitleLabel: UILabel!
  
  override var title: String? {
    get {
      return super.title;
    }
    set(newTitle) {
      super.title = newTitle
      titleLabel.text = title
    }
  }
  
  override var subTitle: String? {
    get {
      return super.subTitle;
    }
    set(newSubTitle) {
      super.subTitle = newSubTitle
      subtitleLabel.text = subTitle
    }
  }
}
