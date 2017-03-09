//
//  settingCell.swift
//  heibaiyu
//
//  Created by jiwei.wang on 2/8/17.
//  Copyright © 2017 yijian. All rights reserved.
//

import Foundation
import UIKit

public class settingCell: UITableViewCell {
  
  private var _model: settingCellModel?
  var model: settingCellModel? {
    get {
      return _model
    }
    set(newModel) {
      _model = newModel
    }
  }
  
  override public func setHighlighted(_ highlighted: Bool, animated: Bool) {
    super.setHighlighted(highlighted, animated: animated)
  }
  
  override public func setSelected(_ selected: Bool, animated: Bool) {}
  
}
