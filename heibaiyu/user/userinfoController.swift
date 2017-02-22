//
//  userinfoController.swift
//  heibaiyu
//
//  Created by jiwei.wang on 2/8/17.
//  Copyright © 2017 yijian. All rights reserved.
//

import Foundation

class userinfoController: settingBaseController  {

  override func viewDidLoad() {
    super.viewDidLoad()
    
    let userdata = netdbwarpper.sharedNetdb().getCurrentUser()!
    let user = try! Chat_User(protobuf: userdata);
    
    // section me
    let meSModel = settingSectionModel()
    // cell me
    let meCModel = settingCellModel()
    meCModel.cellIdentifier = "settingRit_a"
    meCModel.title = L10n.userIcon
    meCModel.icon = user.icon
    meCModel.tap = {
      
    }
    // add cell to section
    meSModel.cellModels = [meCModel]
    
    // add sections
    self.tableDatas = [meSModel]
    self.tableview.reloadData()
    
  }
}
