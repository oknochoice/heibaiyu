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
  
  var tableDatas: [settingSectionModel] = []
  
  //MARK: - delegate datasource
  func numberOfSections(in tableView: UITableView) -> Int {
    return tableDatas.count
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return tableDatas[section].cellModels.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let model = tableDatas[indexPath.section].cellModels[indexPath.row]
    let cell = tableView.dequeueReusableCell(withIdentifier: model.cellIdentifier!, for: indexPath)
    (cell as! settingCell).model = model
    return cell
  }

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if let action = tableDatas[indexPath.section].cellModels[indexPath.row].tap {
      action()
    }
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    let model = tableDatas[indexPath.section].cellModels[indexPath.row]
    if let height = model.cellHeight {
      return height
    }
    return tableView.rowHeight
  }
  
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    return UIView(frame: CGRect.zero)
  }
  
  func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
    return UIView(frame: CGRect.zero)
  }
  
  func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
    return 15
  }
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    if 0 == section {
      return 15
    }
    return 1
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.tableview.tableHeaderView = UITableViewHeaderFooterView(frame: CGRect(x: 1, y: 1, width: 1, height: 1))
    self.tableview.tableFooterView = UITableViewHeaderFooterView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    self.tableview.rowHeight = 44
  }
}
