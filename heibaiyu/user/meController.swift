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
  
  var modelGen: (() -> meModel)?
  
  var isRootController: Bool = false
  
  func fresh() {
    var model: meModel?
    if let gen = modelGen {
      model = gen()
    }else {
      model = meModel.me(vc: self)()
    }
    if let model = model {
      isRootController = model.isRoot
      if isRootController {
        navigationController!.interactivePopGestureRecognizer?.delegate = self
      }
      self.tableDatas = model.sections!
      self.tableview.reloadData()
    }
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    fresh()
    if isRootController {
      self.tabBarController?.tabBar.isHidden = false
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
