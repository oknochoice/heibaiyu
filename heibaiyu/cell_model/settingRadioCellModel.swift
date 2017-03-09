//
//  settingRadioCellModel.swift
//  heibaiyu
//
//  Created by jiwei.wang on 3/9/17.
//  Copyright © 2017 yijian. All rights reserved.
//

import Foundation

class settingRadioCellModel: settingCellModel {
  var radioed: ((Void) -> Void)?
  var didSelect: ((Bool) -> Void)?
  
  fileprivate var _isRadioed: Bool = false {
    didSet {
      if let did = didSelect {
        did(_isRadioed)
      }
    }
  }
  
  var isRadioed: Bool {
    get {
      return _isRadioed
    }
    set (new) {
      _isRadioed = new
    }
  }
  
  weak var section: settingRadioSectionModel?
  func setRadioed() -> Void {
    section?.setRadioModel(selectedModel: self)
    if let cb = radioed {
      cb()
    }
  }
}
