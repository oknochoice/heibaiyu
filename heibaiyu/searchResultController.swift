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
      guard keyword != nil else {
        return
      }
      netdbwarpper.sharedNetdb().getUser(keyword!, "86", { (errno, errmsg) in
        DispatchQueue.main.async {
          if 0 == errno {
            let friendinfo = StoryboardScene.Search.instantiateFriendInfoController()
            let nav = UINavigationController(rootViewController: friendinfo)
            self.present(nav, animated: true, completion: nil)
          }else {
            errorLocal.error(err_no: errno, orMsg: errmsg)
          }
        }
      })
    }
    
    section.cellModels = [search]
    self.tableDatas?.append(section)
  }
}
