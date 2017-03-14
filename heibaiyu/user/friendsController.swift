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
    
    loadFriends()
    
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.tabBarController?.tabBar.isHidden = false
  }
  
  func loadFriends() {
    let user_data = netdbwarpper.sharedNetdb().dbGetCurrentUser()
    if let data = user_data, let user = try? Chat_User(protobuf: data) {
      for info in user.friends {
        
      }
    }
    tableview.reloadData()
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
