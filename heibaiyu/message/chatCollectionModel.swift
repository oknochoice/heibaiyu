//
//  chatCollectionModel.swift
//  heibaiyu
//
//  Created by yijian on 3/19/17.
//  Copyright © 2017 yijian. All rights reserved.
//

import Foundation

class chatCollectionModel {
  
  class Delegates {
    var sendMsgCallback: ((Int32, String) -> Void)?
  }
  var delegates: Delegates = Delegates()
  
  enum Status {
    case success,
    failure,
    sending,
    prepare
  }
  var msgmodel: messageModel!
  var cellIdentifier: String = ""
  var isIncoming: Bool = true
  var status: Status = .success
  var text: String = "no content"
  func clearDelegates() {
    delegates.sendMsgCallback = nil
  }
  func send() {
    netdbwarpper.sharedNetdb().sendMessage(
      msgmodel.tonodeid ?? "",
      msgmodel.tonodeid ?? "",
      Int32(Chat_MediaType.text.rawValue),
      text) { [weak self] (errno, errmsg) in
        DispatchQueue.main.async {
          if let ss = self, let callback = ss.delegates.sendMsgCallback {
            if 0 == errno {
              ss.status = .success
            }else {
              ss.status = .failure
            }
            callback(errno, errmsg)
          }
        }
    }
  }
}
