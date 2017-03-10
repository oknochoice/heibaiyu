//
//  searchController.swift
//  heibaiyu
//
//  Created by jiwei.wang on 2/7/17.
//  Copyright © 2017 yijian. All rights reserved.
//

import Foundation
import UIKit

class searchResultController: settingBaseController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.title = L10n.searchAddFriend
    tableview.rowHeight = 64
    tableDatas = []
  }
  
  func load(keyword:String?) {
    tableDatas = []
    appendSearchUser(keyword: keyword)
    self.tableview.reloadData()
  }
  
  func appendSearchUser(keyword: String?) {
    let section = settingSectionModel()
    let search = settingCellModel()
    search.cellIdentifier = "settingLits_a"
    search.iconImage = #imageLiteral(resourceName: "placeholderimage")
    search.title = L10n.searchFriendTip
    search.subTitle = keyword
    search.tap = {
      let friendinfo = StoryboardScene.Search.instantiateFriendInfoController()
      self.present(friendinfo, animated: true, completion: nil)
    }
    
    section.cellModels = [search]
    self.tableDatas?.append(section)
  }
}
