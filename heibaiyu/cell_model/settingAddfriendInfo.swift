//
//  settingAddfriendInfo.swift
//  heibaiyu
//
//  Created by yijian on 3/12/17.
//  Copyright © 2017 yijian. All rights reserved.
//

import Foundation

class settingAddfriendInfo: settingCell {
  
  @IBOutlet weak var icon: UIImageView!
  @IBOutlet weak var title: UILabel!
  @IBOutlet weak var friendStatus: UIButton!
  override var model: settingCellModel? {
    get {
      return super.model
    }
    set (new) {
      super.model = new
      if let icons = new?.icon {
        icon.sd_setImage(with: URL(string: icons), placeholderImage: #imageLiteral(resourceName: "placeholderimage"))
      }else if let image = new?.iconImage {
        icon.image = image
      }
      title.text = new?.title
      if let statusDesc = new?.subTitle {
        if statusDesc == L10n.friendStatusAdded {
          friendStatus.setTitle(new?.subTitle, for: .disabled)
          friendStatus.isEnabled = false
        }else {
          friendStatus.setTitle(new?.subTitle, for: .normal)
          friendStatus.isEnabled = true
        }
      }
      friendStatus.addTarget(self, action: #selector(addOrAuthorize), for: .touchUpInside)
    }
  }
  
  func addOrAuthorize() {
    let friendModel = model as! settingFriendModel
    if model?.subTitle == L10n.friendStatusAdd {
      netdbwarpper.sharedNetdb().addFiend(friendModel.userid!, "", { (errno, errmsg) in
        DispatchQueue.main.async {
          if 0 == errno {
            errorLocal.success(msg: L10n.friendAddQuerySended)
          }else {
            errorLocal.error(err_no: errno, orMsg: errmsg)
          }
        }
      })
    }else if model?.subTitle == L10n.friendStatusAuthorize {
      netdbwarpper.sharedNetdb().addfiendAuthorize(friendModel.userid!, true, { (errno, errmsg) in
        DispatchQueue.main.async { [weak self] in
          if 0 == errno {
            errorLocal.success(msg: L10n.friendAddAuthorized)
            self?.friendStatus.isEnabled = false
          }else {
            errorLocal.error(err_no: errno, orMsg: errmsg)
          }
        }
      })
    }
  }
}
