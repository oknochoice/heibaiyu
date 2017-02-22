//
//  image.swift
//  heibaiyu
//
//  Created by yijian on 1/30/17.
//  Copyright © 2017 yijian. All rights reserved.
//

import Foundation
import UIKit

public extension UIImage {
  
  // init
  public convenience init?(color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) {
    let rect = CGRect(origin: .zero, size: size)
    UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
    color.setFill()
    UIRectFill(rect)
    let image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    guard let cgImage = image?.cgImage else { return nil }
    self.init(cgImage: cgImage)
  }
  
  
}
