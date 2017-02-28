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
  
  var memodel: meModel?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    if let me = memodel {
      self.tableDatas = me.sections
      self.tableview.reloadData()
    }else {
      memodel = meModel.me(nav: self.navigationController)
      navigationController!.interactivePopGestureRecognizer?.delegate = self
      self.tableDatas = memodel!.sections
      self.tableview.reloadData()
    }
    
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    if let me = memodel {
      if me.isRoot {
        self.tabBarController?.tabBar.isHidden = false
      }
    }
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
