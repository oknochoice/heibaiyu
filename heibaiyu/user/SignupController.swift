//
//  SignupController.swift
//  heibaiyu
//
//  Created by jiwei.wang on 1/20/17.
//  Copyright © 2017 yijian. All rights reserved.
//

import UIKit
import Whisper

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
        let mur = Murmur(title: L10n.signupPasswordLimit, backcolor: UIColor(named: .tenghuang))
        Whisper.show(whistle: mur, action: .show(1.5))
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
            let json = try signupRes.serializeJSON()
            blog.debug(json)
            if signupRes.isSuccess {
              DispatchQueue.main.async {
                self.signup.title(title: L10n.signupSendVerifycode)
                self.verifyHeight.constant = 30
                self.signup.stopAnimation()
                self.countdownTimer.start()
              }
            }else {
              let mur = Murmur(title: signupRes.eMsg, backcolor: UIColor(named: .tenghuang))
              DispatchQueue.main.async {
                Whisper.show(whistle: mur, action: .show(1.5))
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
        let data = try signup_data.serializeProtobuf()
        netyiwarpper.netyi_signup_login_connect(with: ChatType.registor.rawValue, data: data, cb: { (type, indata, isStop) in
          //blog.debug(data)
        DispatchQueue.main.async {
          do {
            let signupRes = try Chat_RegisterRes(protobuf: indata)
            let json = try signupRes.serializeJSON()
            blog.debug(json)
            if signupRes.isSuccess {
                let mur = Murmur(title: L10n.signupSuccess, backcolor: UIColor(named: .congqian))
                  Whisper.show(whistle: mur, action: .show(1))
            }else {
                let mur = Murmur(title: signupRes.eMsg, backcolor: UIColor(named: .tenghuang))
                Whisper.show(whistle: mur, action: .show(1.5))
            }
          } catch {
            blog.debug(error)
          }
        }
        })
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
  func getVerifycode() {
    /*
    do {
      let data = try signup_data.serializeProtobuf()
      let sdata = String(data: data, encoding: String.Encoding.utf8)
      netyiwarpper.netyi_signup_login_connect(with: ChatType.registor.rawValue, data: sdata!, cb: { (type, indata, isStop) in
        //blog.debug(data)
        do {
          let signupRes = try Chat_RegisterRes(protobuf: indata.data(using: .utf8)!)
          let json = try signupRes.serializeJSON()
          blog.debug(json)
          if signupRes.isSuccess {
            DispatchQueue.main.async {
              let mur = Murmur(title: L10n.signupSuccess, backcolor: UIColor(named: .congqian))
              if isCheck {
              }else {
                Whisper.show(whistle: mur, action: .show(1))
              }
            }
          }else {
            DispatchQueue.main.async {
              let mur = Murmur(title: signupRes.eMsg, backcolor: UIColor(named: .tenghuang))
              Whisper.show(whistle: mur, action: .show(1.5))
            }
          }
        } catch {
          blog.debug(error)
        }
      })
    } catch {
      blog.debug(error)
    }
    let delay = DispatchTime.now() + .seconds(3)
    DispatchQueue.main.asyncAfter(deadline: delay) { 
    }
 */
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
