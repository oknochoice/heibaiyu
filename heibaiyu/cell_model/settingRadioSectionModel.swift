//
//  settingRadioSectionModel.swift
//  heibaiyu
//
//  Created by jiwei.wang on 3/9/17.
//  Copyright © 2017 yijian. All rights reserved.
//

import Foundation

class settingRadioSectionModel: settingSectionModel {
  func setRadioModel(selectedModel: settingRadioCellModel) -> Void {
    if let models = self.cellModels {
      for item in models {
        let model = item as! settingRadioCellModel
        if model !== selectedModel {
          model.isRadioed = false
        }else {
          model.isRadioed = true
        }
      }
    }
  }
}
