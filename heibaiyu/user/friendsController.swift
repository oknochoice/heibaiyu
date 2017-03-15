//
//  friendsController.swift
//  heibaiyu
//
//  Created by jiwei.wang on 1/24/17.
//  Copyright © 2017 yijian. All rights reserved.
//

import UIKit

class friendsController: settingBaseController {

  lazy var searchController: UISearchController = {
    let search = UISearchController(searchResultsController: StoryboardScene.Search.instantiateSearchResultController())
    search.searchResultsUpdater = self
    search.dimsBackgroundDuringPresentation = true
    search.hidesNavigationBarDuringPresentation = true
    self.definesPresentationContext = true
    return search
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let searchbar = searchController.searchBar
    tableview.tableHeaderView = searchbar
    searchbar.autocorrectionType = .no
    searchbar.autocapitalizationType = .none
    searchbar.spellCheckingType = .no
    searchbar.sizeToFit()
    searchbar.delegate = self
    
    self.tableview.rowHeight = 64
    
    loadFriendsFromLocal()
    loadFriendsFromNet()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.tabBarController?.tabBar.isHidden = false
    
  }
  
  func loadFriendsFromLocal() {
    self.tableDatas = [];
    let user = userCurrent.shared()
    if let friends = user?.friends {
      self.tableDatas.append(settingSectionModel())
      for info in friends { 
        let cellmodel = settingFriendModel()
        cellmodel.cellIdentifier = "friendCell"
        cellmodel.userid = info.userId
        cellmodel.tonodeid = info.toNodeId
        let friend_data = netdbwarpper.sharedNetdb().dbGetUser(info.userId)
        if let data = friend_data, let friend = try? Chat_User(protobuf: data) {
          cellmodel.title = String.getNonNil([friend.nickname, friend.realname, friend.phoneNo])
          cellmodel.icon = String.http(relativePath: friend.icon)
        }else {
          cellmodel.title = info.userId
        }
        cellmodel.tap = {
          let infoController = StoryboardScene.Search.instantiateFriendInfoController()
          infoController.isNeedSendField = false
          infoController.userid = info.userId
          let nav = UINavigationController(rootViewController: infoController)
          self.present(nav, animated: true, completion: nil)
        }
        self.tableDatas.first?.cellModels.append(cellmodel)
      }
      self.tableview.reloadData()
    }

}
func loadFriendsFromNet() {
  netdbwarpper.sharedNetdb().updateUserAndFriends { [weak self] (errno, errmsg) in
    DispatchQueue.main.async { [weak self] in
      self?.loadFriendsFromLocal()
    }
  }
}

}

extension friendsController: UISearchBarDelegate {
  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    updateSearchResults(for: searchController)
  }
}

extension friendsController: UISearchResultsUpdating {
  func updateSearchResults(for searchController: UISearchController) {
    if let controller = searchController.searchResultsController as? searchResultController {
      controller.load(keyword: searchController.searchBar.text)
    }
  }
}
