//
//  meIconController.swift
//  heibaiyu
//
//  Created by jiwei.wang on 2/23/17.
//  Copyright © 2017 yijian. All rights reserved.
//

import Foundation
import SnapKit

class meIconController: baseViewController {
  var imageview = imageScroll();
		
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.addSubview(imageview)
    self.automaticallyAdjustsScrollViewInsets = false
    imageview.backgroundColor = Color.green
    imageview.snp.makeConstraints { (make) in
      make.left.equalToSuperview()
      make.right.equalToSuperview()
      make.top.equalToSuperview()
      make.bottom.equalToSuperview()
    }
  }
}
