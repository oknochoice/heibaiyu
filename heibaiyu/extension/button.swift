//
//  button.swift
//  heibaiyu
//
//  Created by yijian on 1/30/17.
//  Copyright © 2017 yijian. All rights reserved.
//

import Foundation
import DynamicColor

public extension UIButton {
  
  public func color(dcolor: DynamicColor) {
    let normalImage = UIImage(color: dcolor, size: self.frame.size)
    let highImage = UIImage(color: dcolor.lighter(), size: self.frame.size)
    let disableImage = UIImage(color: dcolor.grayscaled(), size: self.frame.size)
    self.setBackgroundImage(normalImage, for: UIControlState.normal)
    self.setBackgroundImage(highImage, for: UIControlState.highlighted)
    self.setBackgroundImage(disableImage, for: UIControlState.disabled)
  }
  
  public func title(title: String) {
    self.setTitle(title, for: UIControlState.normal)
    self.setTitle(title, for: UIControlState.highlighted)
    self.setTitle(title, for: UIControlState.disabled)
  }
  
  public func greenbackWhiteword() {
    let dcolor = DynamicColor(named: .congqian)
    color(dcolor: dcolor)
  }
}
