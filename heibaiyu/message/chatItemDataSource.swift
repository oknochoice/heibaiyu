//
//  chatDataSource.swift
//  heibaiyu
//
//  Created by jiwei.wang on 3/16/17.
//  Copyright © 2017 yijian. All rights reserved.
//

import Foundation
import Chatto

class chatItemDataSource: ChatDataSourceProtocol {
  var hasMoreNext: Bool {
    return true
  }
  var hasMorePrevious: Bool {
    return true
  }
  var chatItems: [ChatItemProtocol] {
    return []
  }
  var delegate: ChatDataSourceDelegateProtocol?
  func loadNext() {
  }
  func loadPrevious() {
  }
  func adjustNumberOfMessages(preferredMaxCount: Int?, focusPosition: Double, completion: ((Bool)) -> Void) {
  }
  
  
  // add 
  func addTextMessage(_ text: String) {
    
  }
  func addPhotoMessage(_ image: UIImage) {
    
  }
}
