//
//  SignupController.swift
//  heibaiyu
//
//  Created by jiwei.wang on 1/20/17.
//  Copyright © 2017 yijian. All rights reserved.
//

import UIKit
import SwiftyBeaver
import DynamicColor
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
    
  }
  
  override func didReceiveMemoryWarning() {
      super.didReceiveMemoryWarning()
      // Dispose of any resources that can be recreated.
  }
  
  
  
  @IBAction func signup(_ sender: UIButton) {
    
    if signup.title(for: UIControlState.normal) == L10n.signupSignup {
      if password.text!.lengthOfBytes(using: .utf8) < 6 {
        let mur = Murmur(title: L10n.signupPasswordLimit, backgroundColor: UIColor(named: .tenghuang), titleColor: .white, font: UIFont.systemFont(ofSize: 12), action: nil)
        Whisper.show(whistle: mur, action: .show(1.5))
        return
      }else {
        getVerifycode()
      }
    }else {
      var signup = Chat_Register()
      signup.countryCode = "86"
      signup.phoneNo = phoneno.text!
      signup.nickname = phoneno.text!
      signup.password = password.text!
      signup.verifycode = verifycode.text!
      
      do {
        let data = try signup.serializeProtobuf()
        let sdata = String(data: data, encoding: String.Encoding.utf8)
        netyiwarpper.netyi_signup_login_connect(with: ChatType.registor.rawValue, data: sdata!, cb: { (type, indata, isStop) in
          //blog.debug(data)
          do {
            let signupRes = try Chat_RegisterRes(protobuf: indata.data(using: .utf8)!)
            print(try signupRes.serializeJSON())
          } catch {
            print(error)
          }
        })
      } catch {
        print(error)
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
  func getVerifycode() {
    signup.startAnimation()
    phoneno.isEnabled = false
    password.isEnabled = false
    password.isSecureTextEntry = true
    let delay = DispatchTime.now() + .seconds(3)
    DispatchQueue.main.asyncAfter(deadline: delay) { 
      self.signup.title(title: L10n.signupSendVerifycode)
      self.verifyHeight.constant = 30
      self.signup.stopAnimation()
      self.countdownTimer.start()
    }
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
