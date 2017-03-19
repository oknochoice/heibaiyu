//
//  chatCollectionModel.swift
//  heibaiyu
//
//  Created by yijian on 3/19/17.
//  Copyright © 2017 yijian. All rights reserved.
//

import Foundation

class chatCollectionModel {
  enum Status {
    case success,
    failure,
    sending
  }
  var isIncoming: Bool = true
  var status: Status = .success
  var text: String = "no content"
}
