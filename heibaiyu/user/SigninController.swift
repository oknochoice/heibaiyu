//
//  SigninController.swift
//  heibaiyu
//
//  Created by yijian on 1/24/17.
//  Copyright © 2017 yijian. All rights reserved.
//

import UIKit
import Device

class SigninController: UIViewController {

  @IBOutlet weak var phoneno: UITextField!
  @IBOutlet weak var password: UITextField!
  
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
      let tap = UITapGestureRecognizer(target: self, action: #selector(resignFirstResponse))
      self.view.addGestureRecognizer(tap)
      if (self.phoneno.text?.isEmpty)! {
        self.phoneno.becomeFirstResponder()
      }else {
        self.password.becomeFirstResponder()
      }
    }
  func resignFirstResponse() {
    self.phoneno.resignFirstResponder()
    self.password.resignFirstResponder()
  }

  @IBAction func enroll(_ sender: UIButton) {
    self.present(StoryboardScene.Main.instantiateSignupController(), animated: true, completion: nil)
  }
  @IBAction func signin(_ sender: IndicatorButton) {
    var device = Chat_Device()
    device.os = Chat_Device.OperatingSystem.iOs
    device.deviceModel = Device.version().rawValue
    device.uuid = (UIDevice.current.identifierForVendor?.uuidString)!
    var signin = Chat_Login()
    signin.countryCode = "86"
    signin.phoneNo = phoneno.text!
    signin.password = password.text!
    signin.device = device
    if let logindata = try? signin.serializeProtobuf() {
      sender.startAnimation()
      netyiwarpper.netyi_signup_login_connect(with: ChatType.login.rawValue, data: logindata, cb: { [weak self] (type, data, isStop) in
      DispatchQueue.main.async {[weak self] in
        if let res = try? Chat_LoginRes(protobuf: data) {
          blog.verbose(try! res.serializeAnyJSON())
          if res.isSuccess == true {
            leveldb.sharedInstance.putCurrentUserid(userid: res.userId)
            self!.connect()
          }else {
            sender.stopAnimation()
            errorLocal.error(err_no: res.eNo, orMsg: res.eMsg)
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
          if (Int16)(ChatType.clientconnectres.rawValue) == type {
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
        if ChatType.error.Int16Value() == type {
          let err = try! Chat_Error(protobuf: data)
          errorLocal.error(err_no: err.errnum, orMsg: err.errmsg)
        }else {
          let res = try! Chat_QueryUserRes(protobuf: data)
          leveldb.sharedInstance.putUser(user: res.user)
          userinfo.change2barController()
          blog.verbose(try! res.serializeAnyJSON())
        }
      }
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
