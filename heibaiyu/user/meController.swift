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
    let me = settingSectionModel()
    let meCell = settingCellModel()
    meCell.cellIdentifier = "settingLits_a"
    meCell.title = "1"
    meCell.subTitle = "2"
    me.cellModels = [meCell]
    self.tableDatas = [me]
    self.tableview.reloadData()
  }
  
}
