//
//  settingRadio.swift
//  heibaiyu
//
//  Created by jiwei.wang on 3/9/17.
//  Copyright © 2017 yijian. All rights reserved.
//

import Foundation

class settingRadio: settingCell {
  
  @IBOutlet weak var titile: UILabel!
  @IBOutlet weak var imageTip: UIImageView!
  
  override var model: settingCellModel? {
    get {
      return super.model
    }
    set (new) {
      super.model = new
      titile.text = new?.title
      if let new = new as? settingRadioCellModel {
        if new.isRadioed {
          imageTip.image = #imageLiteral(resourceName: "successful")
        }else {
          imageTip.image = nil
        }
        new.didSelect = {[weak self] in
          if $0 {
            self?.imageTip.image = #imageLiteral(resourceName: "successful")
          }else {
            self?.imageTip.image = nil
          }
        }
      }
    }
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    if let new = model as? settingRadioCellModel{
      new.didSelect = nil
    }
  }
  
}
