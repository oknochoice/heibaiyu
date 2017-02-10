//
//  settingCell.swift
//  heibaiyu
//
//  Created by jiwei.wang on 2/8/17.
//  Copyright © 2017 yijian. All rights reserved.
//

import Foundation

class settingCell: UITableViewCell {
  var tap: ((Void) -> Void)?
  var title: String?
  var subTitle: String?
  var icon: String?
  var cellHeight: Double?
  private var _model: settingCellModel?
  var model: settingCellModel? {
    get {
      return _model
    }
    set(newModel) {
      _model = newModel
      title = model?.title
      subTitle = model?.subTitle
      icon = model?.icon
      tap = model?.tap
      cellHeight = model?.cellHeight
    }
  }
}
