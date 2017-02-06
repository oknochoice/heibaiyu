//
//  leveldb.swift
//  heibaiyu
//
//  Created by yijian on 2/5/17.
//  Copyright © 2017 yijian. All rights reserved.
//

import Foundation

public class leveldb {
  static let sharedInstance: leveldb = {
    var instance = leveldb()
    return instance
  }()
  init() {
    let document = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] 
    let path = document.appending("/level.db")
    leveldbwarpper.open_db(with: path)
  }
  deinit {
    leveldbwarpper.close_db()
  }
  // user
  func userKey(id: String) -> String {
    return "u_" + id
  }
  func userKey(phone:String, countryCode: String) -> String {
    return "p_" + countryCode + "_" + phone
  }
  func currentUserKey() -> String {
    return "current_user"
  }
  func put(user: Chat_User) {
    do {
      let data = try user.serializeProtobuf()
      let userid = userKey(id: user.id)
      let phone = userKey(phone: user.phoneNo, countryCode: user.countryCode)
      leveldbwarpper.db_put(with: phone, data: userid.data(using: .utf8)!)
      leveldbwarpper.db_put(with: userid, data: data)
    } catch {
      blog.debug(error)
    }
  }
  func get(id: String) -> Chat_User? {
    do {
      let data = leveldbwarpper.db_get(with: id)
      let user = try Chat_User(protobuf: data!)
      return user
    } catch {
      blog.debug(error)
      return nil
    }
  }
  func get(phone: String, countryCode: String) -> Chat_User? {
    do {
      if let key = leveldbwarpper.db_get(with: userKey(phone: phone, countryCode: countryCode)) {
        if let re = get(id: String(data: key, encoding: .utf8)!) {
          return re
        }
      }
      return nil
    } catch {
      blog.debug(error)
      return nil
    }
  }
  func getCurrentUserid() -> String? {
    if let data = leveldbwarpper.db_get(with: currentUserKey()) {
      return String(data: data, encoding: .utf8)
    }
    return nil
  }
  func putCurrentUserid(userid: String) {
    leveldbwarpper.db_put(with: currentUserKey(), data: userid.data(using: .utf8)!)
  }
  func putCurrentUser(user: Chat_User) {
    put(user: user)
    putCurrentUserid(userid: user.id)
  }
  func getCurrentUser() -> Chat_User? {
    if let data = leveldbwarpper.db_get(with: currentUserKey()) {
      if let re = get(id: String(data: data, encoding: .utf8)!) {
        return re
      }
    }
    return nil
  }
}
