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
  
}
