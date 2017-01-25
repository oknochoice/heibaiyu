//
//  SignupController.swift
//  heibaiyu
//
//  Created by jiwei.wang on 1/20/17.
//  Copyright © 2017 yijian. All rights reserved.
//

import UIKit
import PhoneNumberKit

class SignupController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
    var signup = Chat_Register()
    signup.countryCode = "86"
    signup.phoneNo = "18514020000"
    signup.nickname = "yijian_ios_client_1"
    signup.password = "123456"
    signup.verifycode = "1234"
    
    do {
      var data = try signup.serializeProtobuf()
      let p = UnsafeMutablePointer<UInt8>.allocate(capacity: 1024)
      data.copyBytes(to: p, count: data.count)
      netyi_signup_login_conect(1, p, Int32(data.count), { (type, header, length, isStop) in
        print(header)
      })
    } catch {
      print(error)
    }
  }

  override func didReceiveMemoryWarning() {
      super.didReceiveMemoryWarning()
      // Dispose of any resources that can be recreated.
  }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
