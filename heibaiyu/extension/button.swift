//
//  button.swift
//  heibaiyu
//
//  Created by yijian on 1/30/17.
//  Copyright © 2017 yijian. All rights reserved.
//

import Foundation
import DynamicColor

extension UIButton {
  
  func color(dcolor: DynamicColor) {
    let normalImage = UIImage(color: dcolor, size: self.frame.size)
    let highImage = UIImage(color: dcolor.lighter(), size: self.frame.size)
    self.setBackgroundImage(normalImage, for: UIControlState.normal)
    self.setBackgroundImage(highImage, for: UIControlState.highlighted)
  }
  
  func greenbackWhiteword() {
    let dcolor = DynamicColor(named: .congqian)
    color(dcolor: dcolor)
  }
}
