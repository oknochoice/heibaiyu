//
//  chatLayout.swift
//  heibaiyu
//
//  Created by yijian on 3/19/17.
//  Copyright © 2017 yijian. All rights reserved.
//

import Foundation

class chatLayout: UICollectionViewLayout {
  func appendItem(item: chatCollectionModel) {
    let count = datas.count
    datas.append(item)
    //let attributes = UICollectionViewLayoutAttributes(forCellWith: IndexPath(item: count, section: 0))
    //attributes.frame = attributesFrame(item: count)
    //datasAttributesCache.append(attributes)
  }
  //var cell:chatCollectionCell!
  func resetItems(items: [chatCollectionModel]) {
    datas = items
  }
  var scrollDirection: UICollectionViewScrollDirection = .vertical
  fileprivate var datas: [chatCollectionModel] = []
  
  let headerHeight: CGFloat = 64
  fileprivate var datasAttributesCache: Array<UICollectionViewLayoutAttributes> = []
  
  override var collectionViewContentSize: CGSize {
    return CGSize(width: contentWidth, height: contentHeight)
  }
  
  override func prepare() {
    contentWidth = (collectionView?.frame.width)!
    labelWidth = contentWidth - 60 - 15
    let itemcount = collectionView!.numberOfItems(inSection: 0)
    let from = datasAttributesCache.count
    for item in from ..< itemcount {
      let attributes = UICollectionViewLayoutAttributes(forCellWith: IndexPath(item: item, section: 0))
      attributes.frame = attributesFrame(item: item)
      datasAttributesCache.append(attributes)
    }
  }
  fileprivate var contentWidth: CGFloat = 0
  fileprivate var contentHeight: CGFloat = 0
  fileprivate var labelWidth: CGFloat = 0
  fileprivate var cellHeightOther: CGFloat = 10 + 10
  fileprivate var label: UILabel = {
    let l = UILabel()
    l.numberOfLines = 0
    return l
  }()
  fileprivate func attributesFrame(item: Int) -> CGRect {
    var y: CGFloat = 0.0
    if let last = datasAttributesCache.last {
      y = last.frame.maxY
    }else {
      y = headerHeight
    }
    let model = datas[item]
    label.text = model.text
    let size = label.sizeThatFits(CGSize(width: labelWidth, height: CGFloat.greatestFiniteMagnitude))
    let height = size.height + cellHeightOther
    let width: CGFloat = (collectionView?.frame.width)!
    if contentHeight < y + height {
      contentHeight = y + height
    }
    return CGRect(x: 0, y: y, width: width, height: height)
  }
  override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
    let re = datasAttributesCache.filter({ (attributes) -> Bool in
      attributes.frame.intersects(rect) 
    })
    return re
  }
  override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
    return datasAttributesCache.first(where: { (attributes) -> Bool in
      attributes.indexPath == indexPath
    })
  }
  override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
    return false
  }
}
