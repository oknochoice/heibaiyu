//
//  imageScroll.swift
//  heibaiyu
//
//  Created by jiwei.wang on 2/23/17.
//  Copyright © 2017 yijian. All rights reserved.
//

import Foundation

class phMedia {
  enum SourceType {
    case
    none,
    image,
    imageUrl
  }
  fileprivate var mtype_ = SourceType.none
  fileprivate var image_: UIImage?
  fileprivate var url_: String?
  init(image: UIImage) {
    image_ = image
    mtype_ = SourceType.image
  }
  init(imageurl: String) {
    url_ = imageurl
    mtype_ = SourceType.imageUrl
  }
}

class imageScroll: UIScrollView, UIScrollViewDelegate {
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    initsetup()
  }
  
  convenience init() {
    self.init(frame: CGRect.zero)
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  override func awakeFromNib() {
    initsetup()
  }
  
  var media: phMedia? {
    didSet {
      if let m = media {
        if m.mtype_ == phMedia.SourceType.image {
          imageview.image = m.image_
          imageSize = (m.image_?.size)!
          setup()
        }else if m.mtype_ == phMedia.SourceType.imageUrl {
          imageview.sd_setImage(with: URL(fileURLWithPath: m.url_!), placeholderImage: nil, options: .progressiveDownload, completed: {[weak self] (image, error, type, url) in
            self?.imageview.image = image
            self?.imageSize = (image?.size)!
            self?.setup()
          })
        }else {
          blog.error()
        }
      }
    }
  }
  
  fileprivate var imageview = UIImageView()
  fileprivate func initsetup() {
    
    let image = #imageLiteral(resourceName: "taikong")
    imageview.image = image
    imageSize = image.size
    
    self.addSubview(imageview)
    self.delegate = self
    let singleTap = UITapGestureRecognizer(target: self, action: #selector(singleTap(ges:)))
    singleTap.numberOfTapsRequired = 1
    singleTap.numberOfTouchesRequired = 1
    
    let doubleTap = UITapGestureRecognizer(target: self, action: #selector(self.doubleTap(ges:)))
    doubleTap.numberOfTapsRequired = 2
    doubleTap.numberOfTouchesRequired = 1
    
    // 允许优先执行doubleTap, 在doubleTap执行失败的时候执行singleTap
    // 如果没有设置这个, 那么将只会执行singleTap 不会执行doubleTap
    singleTap.require(toFail: doubleTap)
    
    addGestureRecognizer(singleTap)
    addGestureRecognizer(doubleTap)
  
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    maySetup()
  }
  
  func viewForZooming(in scrollView: UIScrollView) -> UIView? {
    return imageview
  }
  func scrollViewDidZoom(_ scrollView: UIScrollView) {
    fixedContentInset()
  }
  
  fileprivate var imageSize: CGSize = CGSize.zero
  fileprivate var currentOri = UIInterfaceOrientation.portrait
  fileprivate var isNeedResetup_ = true
  fileprivate func maySetup() {
    if isNeedResetup_ || currentOri != UIApplication.shared.statusBarOrientation {
      setup()
    }
  }
  fileprivate func setup() {
    isNeedResetup_ = false
    currentOri = UIApplication.shared.statusBarOrientation
    
    self.maximumZoomScale = imageSize.width / self.bounds.size.width / UIScreen.main.scale
    self.minimumZoomScale = 1
    self.zoomScale = 1
    
    let sSize = self.bounds.size
    
    imageview.contentMode = .scaleAspectFit
    imageview.frame = CGRect(x: 0, y: 0, width: sSize.width, height: imageSize.height / imageSize.width * sSize.width)
    if imageview.frame.height > sSize.height {
      self.maximumZoomScale = imageSize.height / sSize.height / UIScreen.main.scale
      imageview.frame = CGRect(x: 0, y: 0, width: imageSize.width / imageSize.height * sSize.height, height: sSize.height)
    }
    
    self.contentSize = CGSize.zero
    fixedContentInset()
  }
  fileprivate func fixedContentInset() {
    let sSize = self.bounds.size
    let verticalPadding = imageview.frame.height < sSize.height ? (sSize.height - imageview.frame.height) / 2 : 0
    let horizontalPadding = imageview.frame.width < sSize.width ? (sSize.width - imageview.frame.width) / 2 : 0
    
    self.contentInset = UIEdgeInsets(top: verticalPadding, left: horizontalPadding, bottom: verticalPadding, right: horizontalPadding)
  }
  
  @objc fileprivate func singleTap(ges: UITapGestureRecognizer) {
  }
  
  @objc fileprivate func doubleTap(ges: UITapGestureRecognizer) {
    if self.zoomScale <= self.minimumZoomScale { // 放大
      
      let location = ges.location(in: self)
      // 放大scrollView.maximumZoomScale倍, 将它的宽高缩小这么多倍
      
      let width = self.imageview.frame.width/self.maximumZoomScale
      let height = imageSize.height / imageSize.width * width
      let rect = CGRect(x: location.x * (1 - 1/self.maximumZoomScale), y: location.y * (1 - 1/self.maximumZoomScale), width: width, height: height)
      // 这个方法会根据提供的rect来缩放, 如果给的宽高小余scrollView的宽高, 将进行相应的倍数放大的操作, 如果大于, 就会进行缩小到最小操作
      self.zoom(to: rect, animated: true)
      
    } else {// 缩小
      self.setZoomScale(self.minimumZoomScale, animated: true)
      
    }
  }
}
