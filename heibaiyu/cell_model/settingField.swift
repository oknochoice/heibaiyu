//
//  settingField.swift
//  heibaiyu
//
//  Created by jiwei.wang on 2/28/17.
//  Copyright © 2017 yijian. All rights reserved.
//

import Foundation

class settingField: settingCell {
  
  @IBOutlet weak var field: UITextField!
  
  override var title: String? {
    get {
      return super.title
    }
    set (newTitle) {
      super.title = newTitle
      field.text = newTitle
    }
  }
  
  
}


