//
//  meController.swift
//  heibaiyu
//
//  Created by jiwei.wang on 2/8/17.
//  Copyright © 2017 yijian. All rights reserved.
//

import Foundation
import NavigationStack

class meController: settingBaseController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    navigationController!.interactivePopGestureRecognizer?.delegate = self
    
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
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.tabBarController?.tabBar.isHidden = false
  }
  
}

extension meController: UIGestureRecognizerDelegate {
  func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
    
    if navigationController?.viewControllers.count == 2 {
      return true
    }
    
    if let navigationController = self.navigationController as? NavigationStack {
      navigationController.showControllers()
    }
    
    return false
  }
}
