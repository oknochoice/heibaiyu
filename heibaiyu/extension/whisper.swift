//
//  whisper.swift
//  heibaiyu
//
//  Created by yijian on 2/5/17.
//  Copyright © 2017 yijian. All rights reserved.
//

import Foundation
import Whisper

public extension Murmur {
  public init(title: String, backcolor: UIColor) {
    self.init(title: title, backgroundColor: backcolor, titleColor: .white, font: UIFont.systemFont(ofSize: 12), action: nil)
  }
}

public extension Announcement {
  public init(title: String, subtitle:String?, image: UIImage?) {
    self.init(title: title, subtitle: subtitle, image: image, duration: 2, action: nil)
  }
}
