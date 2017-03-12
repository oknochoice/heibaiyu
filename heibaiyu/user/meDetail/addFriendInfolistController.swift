//
//  addFriendInfolistController.swift
//  heibaiyu
//
//  Created by yijian on 3/12/17.
//  Copyright © 2017 yijian. All rights reserved.
//

import Foundation

class addFriendInfolistController: settingBaseController {
  override func viewDidLoad() {
    super.viewDidLoad()
    load()
  }
  func load() {
    netdbwarpper.sharedNetdb().getAddfriendInfo { (errno, errmsg) in
      DispatchQueue.main.async { [weak self] in
        if 0 == errno {
          let data = netdbwarpper.sharedNetdb().dbGetAddfriends()
          let res = try! Chat_QueryAddfriendInfoRes(protobuf: data!)
          self?.tableDatas = []
          let section = settingSectionModel()
          for info in res.info {
            let model = settingAddfriendModel()
            model.cellIdentifier = "settingAddfriendInfo"
            model.icon = String.http(relativePath: info.invitee)
          }
        }else {
          errorLocal.error(err_no: errno, orMsg: errmsg)
        }
      }
    }
  }
}
