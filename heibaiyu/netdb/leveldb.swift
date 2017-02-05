//
//  leveldb.swift
//  heibaiyu
//
//  Created by yijian on 2/5/17.
//  Copyright © 2017 yijian. All rights reserved.
//

import Foundation

public class leveldb {
  func open(path: String) -> Bool {
    return leveldbwarpper.open_db(with: path)
  }
  func close() {
    leveldbwarpper.close_db()
  }
  // user
  func userKey(id: String) -> String {
    return "u_" + id
  }
  func userKey(phone:String, countryCode: String) -> String {
    return "p_" + countryCode + "_" + phone
  }
  func put(user: Chat_User) {
    do {
      let data = try user.serializeProtobuf()
      let string_data = String(data: data, encoding: .utf8)!
      let userid = userKey(id: user.id)
      let phone = userKey(phone: user.phoneNo, countryCode: user.countryCode)
      leveldbwarpper.db_put(with: phone, data: userid)
      leveldbwarpper.db_put(with: userid, data: string_data)
    } catch {
      blog.debug(error)
    }
  }
  func get(id: String) -> Chat_User? {
    do {
      let s_data = leveldbwarpper.db_get(with: id)
      let user = try Chat_User(protobuf: s_data!.data(using: .utf8)!)
      return user
    } catch {
      blog.debug(error)
      return nil
    }
  }
  func get(phone: String, countryCode: String) -> Chat_User? {
    do {
      let key = leveldbwarpper.db_get(with: userKey(phone: phone, countryCode: countryCode))
      return get(id: key!)
    } catch {
      blog.debug(error)
      return nil
    }
  }
}
