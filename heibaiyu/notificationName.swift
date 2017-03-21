//
//  notificationLocal.swift
//  heibaiyu
//
//  Created by jiwei.wang on 3/14/17.
//  Copyright © 2017 yijian. All rights reserved.
//

import Foundation

public class notificationName {
  // push user talk
  static let talk2user = Notification.Name("talk2user")
  static let talk2user_key_userid = "talk2user_key_userid"
  // update recent message
  static let incomingMsg = Notification.Name("incomingMsg")
  static let incomingMsg_key_nodeid = "incomingMsg_key_nodeid"
  // update send message
  static let updateSendMsg = Notification.Name("updateSendMsg")
  static let updateSendMsg_key_nodeid = "updateSendMsg_key_nodeid"
}
