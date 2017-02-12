//
//  error.swift
//  heibaiyu
//
//  Created by jiwei.wang on 2/7/17.
//  Copyright © 2017 yijian. All rights reserved.
//

import Foundation
import Whisper
import UIKit

public class errorLocal {
  static func error(err_no: Int32?, orMsg: String) {
    var mur: Murmur?
    if let num = err_no, let msg = getErrorMsg(err_no: num) {
      mur = Murmur(title: msg, backcolor: UIColor(named: .tenghuang))
    }else {
      mur = Murmur(title: orMsg, backcolor: UIColor(named: .tenghuang))
    }
    Whisper.show(whistle: mur!, action: .show(1.5))
  }
  static func success(msg: String) {
    let mur = Murmur(title: msg, backcolor: UIColor(named: .congqian))
    Whisper.show(whistle: mur, action: .show(1.5))
  }
  static func getErrorMsg(err_no: Int32) -> String? {
    let key: NSNumber = err_no as NSNumber
    let key_s = key.stringValue
    let value = NSLocalizedString(key_s, comment: key_s)
    if key_s ==  value{
      return nil
    }else {
      return value
    }
  }
}
