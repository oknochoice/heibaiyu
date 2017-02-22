//
//  meController.swift
//  heibaiyu
//
//  Created by jiwei.wang on 2/8/17.
//  Copyright © 2017 yijian. All rights reserved.
//

import Foundation

class meController: settingBaseController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
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
      self.navigationController?.pushViewController(StoryboardScene.Main.instantiateUserinfoController(), animated: true)
    }
    // add cell to section
    meSModel.cellModels = [meCModel]
    
    // add sections
    self.tableDatas = [meSModel]
    self.tableview.reloadData()
    
  }
  
}
