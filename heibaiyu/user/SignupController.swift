//
//  SignupController.swift
//  heibaiyu
//
//  Created by jiwei.wang on 1/20/17.
//  Copyright © 2017 yijian. All rights reserved.
//

import UIKit
import Whisper
import Device

class SignupController: UIViewController {

  @IBOutlet weak var phoneno: UITextField!
  @IBOutlet weak var password: UITextField!
  @IBOutlet weak var verifycode: UITextField!
  
  @IBOutlet weak var signup: IndicatorButton!
  
  @IBOutlet weak var verifyButton: UIButton!
  
  @IBOutlet weak var verifyHeight: NSLayoutConstraint!
  
  
  var countdownTimer: SwiftCountDownTimer!
		
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    initui()
    countdownInit()
    verifyButton.addTarget(self, action: #selector(self.reGetVerifycode), for: UIControlEvents.touchUpInside)
    signup.addTarget(self, action: #selector(self.signupTouchupin(_:)), for: UIControlEvents.touchUpInside)
    
      self.phoneno.becomeFirstResponder()
  }
  
  @IBAction func dismiss(_ sender: UIButton) {
    self.dismiss(animated: true, completion: nil)
  }
  override func didReceiveMemoryWarning() {
      super.didReceiveMemoryWarning()
      // Dispose of any resources that can be recreated.
  }
  
  func enroll(user: inout Chat_Register, isCheck:Bool) {
  
  }
  
  func signupTouchupin(_ sender: IndicatorButton) throws {
    
    var signup_data = Chat_Register()
    signup_data.countryCode = "86"
    signup_data.phoneNo = phoneno.text!
    signup_data.nickname = phoneno.text!
    signup_data.password = password.text!
    signup_data.verifycode = verifycode.text!
    
    if signup.title(for: UIControlState.normal) == L10n.signupSignup {
      if password.text!.lengthOfBytes(using: .utf8) < 6 {
        errorLocal.error(err_no: nil, orMsg: L10n.signupPasswordLimit)
        return
      }else {
        signup.startAnimation()
        phoneno.isEnabled = false
        password.isEnabled = false
        password.isSecureTextEntry = true
        let data = try signup_data.serializeProtobuf()
        netyiwarpper.netyi_signup_login_connect(with: ChatType.registor.rawValue, data: data, cb: { (type, indata, isStop) in
          //blog.debug(data)
          do {
            let signupRes = try Chat_RegisterRes(protobuf: indata)
            let json = try signupRes.serializeAnyJSON()
            blog.verbose(json)
            if signupRes.isSuccess {
              DispatchQueue.main.async {
                self.signup.title(title: L10n.signupSendVerifycode)
                self.verifyHeight.constant = 30
                self.signup.stopAnimation()
                self.countdownTimer.start()
              }
            }else {
              DispatchQueue.main.async {
                errorLocal.error(err_no: signupRes.eNo, orMsg: signupRes.eMsg)
                self.phoneno.isEnabled = true
                self.password.isEnabled = true
                self.password.isSecureTextEntry = false
                self.signup.stopAnimation()
              }
            }
          } catch {
            blog.debug(error)
          }
        })
      }
    }else {
      if verifycode.text!.isEmpty {
        errorLocal.error(err_no: nil, orMsg: L10n.signupVerifiycoeLimit)
        return
      }
        let data = try signup_data.serializeProtobuf()
        netyiwarpper.netyi_signup_login_connect(with: ChatType.registor.rawValue, data: data, cb: { (type, indata, isStop) in
          //blog.debug(data)
        DispatchQueue.main.async {
          if let signupRes = try? Chat_RegisterRes(protobuf: indata) {
            blog.verbose(try! signupRes.serializeAnyJSON())
            if signupRes.isSuccess {
              errorLocal.success(msg: L10n.signupSuccess)
              self.login()
            }else {
              errorLocal.error(err_no: signupRes.eNo, orMsg: signupRes.eMsg)
            }
          }
        }
        })
    }
  }
  
  func login() {
    // login
    var login = Chat_Login()
    login.phoneNo = self.phoneno.text!
    login.countryCode = "86"
    login.password = self.password.text!
    login.device = Chat_Device()
    login.device.os = Chat_Device.OperatingSystem.iOs
    login.device.deviceModel = Device.version().rawValue
    login.device.uuid = UIDevice.current.identifierForVendor!.uuidString
    if let logindata = try? login.serializeProtobuf() {
      netyiwarpper.netyi_signup_login_connect(with: ChatType.login.rawValue, data: logindata, cb: { [weak self] (type, data, isStop) in
      DispatchQueue.main.async {[weak self] in
        if let res = try? Chat_LoginRes(protobuf: data) {
          blog.verbose(try! res.serializeAnyJSON())
          if res.isSuccess == true {
            leveldb.sharedInstance.putCurrentUserid(userid: res.userId)
            self!.connect()
          }
        }
      }
      })
    }
  }
  
  func connect() {
    if let clientConnect = userinfo.getConnect() {
      if let data = try? clientConnect.serializeProtobuf() {
        netyiwarpper.netyi_signup_login_connect(with: ChatType.clientconnect.rawValue, data: data, cb: {[weak self] (type, data, isStop) in
        DispatchQueue.main.async {[weak self] in
          if ChatType.clientconnectres.rawValue == type {
            if let res = try? Chat_ClientConnectRes(protobuf: data) {
              blog.verbose(try! res.serializeAnyJSON())
              if res.isSuccess {
                self!.getUser()
              }else {
                errorLocal.error(err_no: res.eNo, orMsg: res.eMsg)
              }
            }
          }
        }   
        })
      }
    }
  }
  
  func getUser() {
    var query = Chat_QueryUser()
    query.userId = leveldb.sharedInstance.getCurrentUserid()!
    let userdata = try! query.serializeProtobuf()
    netyiwarpper.netyi_send(with: ChatType.queryuser.rawValue, data: userdata) { (type, data, isStop) in
      DispatchQueue.main.async {
        if ChatType.error.rawValue == type {
          let err = try! Chat_Error(protobuf: data)
          errorLocal.error(err_no: err.errnum, orMsg: err.errmsg)
        }else {
          let res = try! Chat_QueryUserRes(protobuf: data)
          leveldb.sharedInstance.putUser(user: res.user)
          self.dismiss(animated: true, completion: nil)
          blog.verbose(try! res.serializeAnyJSON())
        }
      }
    }
    
  }
  
  func countdownInit() {
    countdownTimer = SwiftCountDownTimer(interval: .fromSeconds(1), times: 10, handler: { (timer, lefttime) in
      if 0 == lefttime {
        self.verifyButton.isEnabled = true
        self.verifyButton.setTitle(L10n.signupRegetVerifycode, for: UIControlState.normal)
      }else {
        self.verifyButton.isEnabled = false
        self.verifyButton.setTitle("\(lefttime)s", for: UIControlState.disabled)
      }
    })
  }
  
  // MARK: -
  func initui() {
    signup.greenbackWhiteword()
    signup.title(title: L10n.signupSignup)
    verifyHeight.constant = 0
  }
  func reGetVerifycode() {
    countdownTimer.reCountDown()
    countdownTimer.start()
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
