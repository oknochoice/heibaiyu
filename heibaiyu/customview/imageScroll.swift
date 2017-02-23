//
//  imageScroll.swift
//  heibaiyu
//
//  Created by jiwei.wang on 2/23/17.
//  Copyright © 2017 yijian. All rights reserved.
//

import Foundation

class imageScroll: UIScrollView, UIScrollViewDelegate {
  var imageview = UIImageView()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setup()
  }
  
  convenience init() {
    self.init(frame: CGRect.zero)
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  override func awakeFromNib() {
    setup()
  }
  
  func setup() {
    self.addSubview(imageview)
    self.translatesAutoresizingMaskIntoConstraints = false
    imageview.translatesAutoresizingMaskIntoConstraints = false
    imageview.image = #imageLiteral(resourceName: "taikong")
    var con = [NSLayoutConstraint]()
    con.append(contentsOf: NSLayoutConstraint.constraints(withVisualFormat: "H:|[imageview]|", options: .directionLeadingToTrailing, metrics: nil, views: ["imageview":imageview]))
    con.append(contentsOf: NSLayoutConstraint.constraints(withVisualFormat: "V:|[imageview]|", options: .directionLeadingToTrailing, metrics: nil, views: ["imageview":imageview]))
    NSLayoutConstraint.activate(con)
  }

}
