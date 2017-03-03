//
//  meDataHelper.swift
//  heibaiyu
//
//  Created by jiwei.wang on 2/28/17.
//  Copyright © 2017 yijian. All rights reserved.
//

import Foundation

class meModel {
  var title: String?
  var isRoot: Bool = false
  var sections: [settingSectionModel]?
  var reFreshList: ((Void) -> Void)?
}

extension meModel {
  
  static func me(vc: meController?) -> (() -> meModel ){
    let reCluture = {[weak vc] () -> meModel in
      
      let me = meModel()
      me.isRoot = true
      let userdata = netdbwarpper.sharedNetdb().getCurrentUser()!
      let user = try! Chat_User(protobuf: userdata);
      
      // section me
      let meSModel = settingSectionModel()
      // cell me
      let meCModel = settingCellModel()
      meCModel.cellIdentifier = "settingLits_a"
      let from = user.phoneNo.index(user.phoneNo.endIndex, offsetBy: -4)
      meCModel.subTitle = "*** **** " + user.phoneNo.substring(from: from)
      var title = user.nickname
      if title.isEmpty {
        title = user.realname
      }
      if title.isEmpty {
        title = meCModel.subTitle!
      }
      meCModel.title = title
      meCModel.cellHeight = 66
      meCModel.tap = {
        if let pushvc = vc {
          let userinfovc = StoryboardScene.Main.instantiateMeController()
          userinfovc.memodelCluture = userinfo(vc: pushvc)
          pushvc.navigationController?.pushViewController(userinfovc, animated: true)
        }
      }
      // add cell to section
      meSModel.cellModels = [meCModel]
      
      me.sections = [meSModel]
      return me
    }
    return reCluture
  }
  
  static func userinfo(vc: meController?) -> (() -> meModel ) {
    let reClosure = { [weak vc] () -> meModel in
    
      let me = meModel()
      me.title = L10n.userInfoTitle
      
      let userdata = netdbwarpper.sharedNetdb().getCurrentUser()!
      let user = try! Chat_User(protobuf: userdata);
      
      // section me
      let meSModel = settingSectionModel()
      // cell me
      let meCModel = settingCellModel()
      meCModel.cellIdentifier = "settingRit_a"
      meCModel.title = L10n.userIcon
      meCModel.icon = String.http(relativePath: user.icon)
      meCModel.tap = {[weak meCModel] in
        blog.verbose()
        if let pushvc = vc {
          let meicon = StoryboardScene.MeDetail.instantiateMeIconController()
          meicon.iconpath = meCModel?.icon
          pushvc.navigationController?.pushViewController(meicon, animated: true)
        }
      }
      // cell realname
      let realname = settingCellModel()
      realname.cellIdentifier = "settingts_a"
      realname.title = L10n.userRealname
      realname.subTitle = user.realname
      realname.tap = {
        if let pushvc = vc {
        }
      }
      
      
      // section
      meSModel.cellModels = [meCModel, realname]
      
      me.sections = [meSModel]
      return me
    }
    return reClosure
  }
  
}
