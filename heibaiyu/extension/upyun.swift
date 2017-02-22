//
//  upyun.swift
//  heibaiyu
//
//  Created by jiwei.wang on 2/20/17.
//  Copyright © 2017 yijian. All rights reserved.
//

import Foundation
import SwiftDate

public extension UpYun {
  
  func upload(webp: Data,
              saveKey: String,
              success: @escaping (URLResponse,Any) -> Void,
              failure: @escaping (Error) -> Void,
              progress: @escaping (CGFloat, Int64) -> Void) -> Void {
    self.uploadMethod = UPUploadMethod.mutUPload
    let success_ = success
    let failure_ = failure
    let progress_ = progress
    
    self.successBlocker = {
      (response, responseData) in
      blog.verbose((response, responseData))
      success_(response!, responseData!);
    }
    self.failBlocker = {
      (error) in
      blog.verbose(error)
      failure_(error!)
    }
    self.progressBlocker = {
      (percent:CGFloat, requestDidSendBytes:Int64) in
      blog.verbose((percent, requestDidSendBytes))
      progress_(percent, requestDidSendBytes)
    }
    self.uploadFile(webp, saveKey: saveKey)
  }
  
  // upload
  func upload(image : UIImage,
              success: @escaping (URLResponse,Any) -> Void,
              failure: @escaping (Error) -> Void,
              progress: @escaping (CGFloat, Int64) -> Void) -> Void {
    
    var saveKey: String
    let webp = UIImage.image(toWebP: image, quality: 1)
    if let md5 = NSData.md5HexDigest(webp) {
      if let path = netdbwarpper.sharedNetdb().getMediapath(md5) {
        saveKey = path
      }else {
        let date = DateInRegion();
        let path = date.string(custom: "/yyyy/MM/dd/HH_mm_ss_")
        saveKey = path + String(format: "%08X.webp", arc4random())
      }
      blog.verbose(saveKey)
      netdbwarpper.sharedNetdb().setMediapath(md5, saveKey, { (err_no, err_msg) in
        DispatchQueue.main.async {
          self.upload(webp: UIImage.image(toWebP: image, quality: 1), saveKey: saveKey, success: success, failure: failure, progress: progress);
        }
      })
    }
    
    
  }
}
