//
//  IndicatorButton.swift
//  heibaiyu
//
//  Created by yijian on 2/1/17.
//  Copyright © 2017 yijian. All rights reserved.
//

import Foundation
import SnapKit
import UIKit

class IndicatorButton: UIButton {
  var indicator = UIActivityIndicatorView()
  override func awakeFromNib() {
    indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.white
    self.addSubview(indicator)
  }
  override func setTitle(_ title: String?, for state: UIControlState) {
    if state == UIControlState.normal {
      super.setTitle(title, for: state)
      self.titleLabel?.sizeToFit()
      let width = self.titleLabel?.frame.size.width
      let height = self.titleLabel?.frame.size.height
      indicator.snp.remakeConstraints { (make) in
        make.width.height.equalTo(height!)
        make.centerY.equalTo(self)
        make.centerX.equalTo(self).offset(-((width! + height!) / 2.0))
      }
    }
  }
  public func startAnimation() {
    indicator.startAnimating()
    self.isEnabled = false
  }
  public func stopAnimation() {
    indicator.stopAnimating()
    self.isEnabled = true
  }
}
