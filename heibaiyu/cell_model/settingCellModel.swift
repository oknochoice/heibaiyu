//
//  settingModel.swift
//  heibaiyu
//
//  Created by jiwei.wang on 2/8/17.
//  Copyright © 2017 yijian. All rights reserved.
//

import Foundation
import UIKit

class settingCellModel {
  var tap: ((Void) -> Void)?
  var title: String?
  var subTitle: String?
  var icon: String?
  var cellIdentifier: String!
  var cellHeight: CGFloat?
}