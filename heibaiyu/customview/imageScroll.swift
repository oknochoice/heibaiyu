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
  
  enum GesType {
    case none
    case pinchZoom
    case doubleTapZoomBig
    case doubleTapZoomSmall
  }
  
  var gesture: GesType = .none
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    let image = #imageLiteral(resourceName: "taikong")
    imageview.image = image
    imageview.backgroundColor = Color.blue
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
  
  convenience init() {
    self.init(frame: CGRect.zero)
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    maySetup()
  }
  
  func viewForZooming(in scrollView: UIScrollView) -> UIView? {
    return imageview
  }
  
  func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
  }
  
  func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) {
    if gesture != .doubleTapZoomBig {
      gesture = .pinchZoom
    }
  }
  func scrollViewDidZoom(_ scrollView: UIScrollView) {
    fixedContentInset()
  }
  func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
    gesture = .none
  }
  
  var imageSize: CGSize = CGSize.zero
  var currentOri = UIInterfaceOrientation.portrait
  var isNeedResetup_ = true
  func maySetup() {
    if isNeedResetup_ || currentOri != UIApplication.shared.statusBarOrientation {
      setup()
    }
  }
  func setup() {
    isNeedResetup_ = false
    currentOri = UIApplication.shared.statusBarOrientation
    
    self.maximumZoomScale = imageSize.width / self.bounds.size.width
    self.minimumZoomScale = 1
    self.zoomScale = 1
    
    let sSize = self.bounds.size
    
    imageview.contentMode = .scaleAspectFit
    imageview.frame = CGRect(x: 0, y: 0, width: sSize.width, height: imageSize.height / imageSize.width * sSize.width)
    
    self.contentSize = CGSize.zero
    fixedContentInset()
  }
  func fixedContentInset() {
    let sSize = self.bounds.size
    let verticalPadding = imageview.frame.height < sSize.height ? (sSize.height - imageview.frame.height) / 2 : 0
    let horizontalPadding = imageview.frame.width < imageview.frame.width ? (sSize.width - imageview.frame.width) / 2 : 0
    self.contentInset = UIEdgeInsets(top: verticalPadding, left: horizontalPadding, bottom: verticalPadding, right: horizontalPadding)
  }
  
  func singleTap(ges: UITapGestureRecognizer) {
  }
  
  var isDoubleTap_ = false
  func doubleTap(ges: UITapGestureRecognizer) {
    if self.zoomScale <= self.minimumZoomScale { // 放大
      gesture = .doubleTapZoomBig
      
      let location = ges.location(in: self)
      // 放大scrollView.maximumZoomScale倍, 将它的宽高缩小这么多倍
      let width = self.frame.width/self.maximumZoomScale
      let height = imageSize.height / imageSize.width * width
      let rect = CGRect(x: location.x * (1 - 1/self.maximumZoomScale), y: location.y * (1 - 1/self.maximumZoomScale), width: width, height: height)
      // 这个方法会根据提供的rect来缩放, 如果给的宽高小余scrollView的宽高, 将进行相应的倍数放大的操作, 如果大于, 就会进行缩小到最小操作
      self.zoom(to: rect, animated: true)
      
    } else {// 缩小
      gesture = .doubleTapZoomSmall
      self.setZoomScale(self.minimumZoomScale, animated: true)
      
    }
  }
}
