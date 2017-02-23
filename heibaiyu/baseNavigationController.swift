//
//  baseNavigationController.swift
//  heibaiyu
//
//  Created by jiwei.wang on 2/23/17.
//  Copyright © 2017 yijian. All rights reserved.
//

import Foundation
import NavigationStack

class baseNavigationController: NavigationStack {
  override func pushViewController(_ viewController: UIViewController, animated: Bool) {
    super.pushViewController(viewController, animated: animated)
    self.tabBarController?.tabBar.isHidden = true
  }
  
  override func popViewController(animated: Bool) -> UIViewController? {
    let c = super.popViewController(animated: animated)
    if self.viewControllers.count == 1 {
      self.tabBarController?.tabBar.isHidden = false
    }
    return c
  }
  
  override func popToRootViewController(animated: Bool) -> [UIViewController]? {
    let c = super.popToRootViewController(animated: animated)
    self.tabBarController?.tabBar.isHidden = false
    return c
  }
  
  override func popToViewController(_ viewController: UIViewController, animated: Bool) -> [UIViewController]? {
    let c = super.popToViewController(viewController, animated: animated)
    self.tabBarController?.tabBar.isHidden = false
    return c
  }
}
