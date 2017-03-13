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
    self.tableDatas = []
    load()
  }
  func load() {
    netdbwarpper.sharedNetdb().getAddfriendInfo { (errno, errmsg) in
      DispatchQueue.main.async {
        if 0 == errno {
          let data = netdbwarpper.sharedNetdb().dbGetAddfriends()
          let res = try! Chat_QueryAddfriendInfoRes(protobuf: data!)
          let user = userCurrent.shared()
          let meid = user?.id
          for info in res.info {
            var friendid = info.inviter
            var isAsInviter = false
            if friendid == meid {
              friendid = info.invitee
              isAsInviter = true
            }
            netdbwarpper.sharedNetdb().getUser(friendid, { (errno, errmsg) in
              DispatchQueue.main.async { [weak self] in
                if 0 == errno {
                  let section = settingSectionModel()
                  self?.tableDatas.append(section)
                  let model = settingAddfriendModel()
                  model.cellIdentifier = "settingAddfriendInfo"
                  let frdData = netdbwarpper.sharedNetdb().dbGetUser(friendid)
                  if let frd = try? Chat_User(protobuf: frdData!) {
                    model.userid = friendid
                    model.icon = String.http(relativePath: frd.icon)
                    model.title = String.getNonNil([frd.nickname, frd.realname, frd.phoneNo])
                    if isAsInviter {
                      model.subTitle = L10n.friendStatusAdd
                    }else {
                      model.subTitle = L10n.friendStatusAuthorize
                    }
                    let _ = self?.tableDatas[0].cellModels.append(model)
                    self?.tableview.reloadData()
                  }
                }
              }
            })
          }
        }else {
          errorLocal.error(err_no: errno, orMsg: errmsg)
        }
      }
    }
  }
}
