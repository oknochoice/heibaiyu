//
//  settingBaseController.swift
//  heibaiyu
//
//  Created by jiwei.wang on 2/8/17.
//  Copyright © 2017 yijian. All rights reserved.
//

import Foundation
import UIKit

class settingBaseController: UIViewController, UITableViewDelegate, UITableViewDataSource {
  
  @IBOutlet weak var tableview: UITableView!
  
  var tableDatas: [settingSectionModel]?
  
  //MARK: - delegate datasource
  func numberOfSections(in tableView: UITableView) -> Int {
    if tableDatas != nil {
      return tableDatas!.count
    }else {
      return 0
    }
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return tableDatas![section].cellModels!.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let model = tableDatas![indexPath.section].cellModels![indexPath.row]
    let cell = tableView.dequeueReusableCell(withIdentifier: model.cellIdentifier!, for: indexPath)
    (cell as! settingCell).model = model
    return cell
  }

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if let action = tableDatas![indexPath.section].cellModels![indexPath.row].tap {
      action()
    }
  }
  
  override func viewDidLoad() {
    self.tableview.tableHeaderView = UITableViewHeaderFooterView(frame: CGRect(x: 1, y: 1, width: 1, height: 1))
    self.tableview.tableFooterView = UITableViewHeaderFooterView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
  }
}
