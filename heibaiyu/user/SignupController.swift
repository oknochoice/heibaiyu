//
//  SignupController.swift
//  heibaiyu
//
//  Created by jiwei.wang on 1/20/17.
//  Copyright © 2017 yijian. All rights reserved.
//

import UIKit
import PhoneNumberKit
import SwiftyBeaver

class SignupController: UIViewController {

  @IBOutlet weak var phoneno: UITextField!
  @IBOutlet weak var verifycode: UITextField!
  @IBOutlet weak var indicator: UIActivityIndicatorView!
  @IBOutlet weak var signup: UIButton!
  @IBOutlet weak var signupTitle: UILabel!
  
  @IBOutlet weak var verifyHeight: NSLayoutConstraint!
  
  var abc:String?
		
  override func viewDidLoad() {
    super.viewDidLoad()
    
    initui()
    
  }
  
  override func didReceiveMemoryWarning() {
      super.didReceiveMemoryWarning()
      // Dispose of any resources that can be recreated.
  }
  
  @IBAction func signup(_ sender: UIButton) {
    return
    var signup = Chat_Register()
    signup.countryCode = "86"
    signup.phoneNo = "18514020004"
    signup.nickname = "yijian_ios_client_1"
    signup.password = "123456"
    signup.verifycode = "1234"
    
    do {
      var data = try signup.serializeProtobuf()
      let p = UnsafeMutablePointer<UInt8>.allocate(capacity: 1024)
      data.copyBytes(to: p, count: data.count)
      let sdata = String(data: data, encoding: String.Encoding.utf8)
      netyiwarpper.netyi_signup_login_connect(with: 1, data: sdata!, cb: { (type, data, isStop) in
        blog.debug(data)
      })
    } catch {
      print(error)
    }
  }

  // MARK: - textfield
  
  @IBAction func phonenoDidChanged(_ sender: UITextField) {
  }
  
  // MARK: -
  func initui() {
    signup.greenbackWhiteword()
    verifyHeight.constant = 0
    indicator.hidesWhenStopped = true
    signupTitle.text = L10n.signupGetVerifycode.description
  }
  func getVerifycode() {
    
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
