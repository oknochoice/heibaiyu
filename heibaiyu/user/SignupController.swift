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
    //signup.addTarget(self, action: #selector(self.signupTouchupin(_:)), for: UIControlEvents.touchUpInside)
    
      self.phoneno.becomeFirstResponder()
  }
  
  @IBAction func dismiss(_ sender: UIButton) {
    self.dismiss(animated: true, completion: nil)
  }
  override func didReceiveMemoryWarning() {
      super.didReceiveMemoryWarning()
      // Dispose of any resources that can be recreated.
  }
  
  @IBAction func signupTin(_ sender: IndicatorButton) {
    
    if signup.title(for: UIControlState.normal) == L10n.signupSignup {
      if password.text!.lengthOfBytes(using: .utf8) < 6 {
        errorLocal.error(err_no: nil, orMsg: L10n.signupPasswordLimit)
        return
      }else {
        signup.startAnimation()
        phoneno.isEnabled = false
        password.isEnabled = false
        password.isSecureTextEntry = true
        netdbwarpper.sharedNetdb().registCheck(self.phoneno.text!, "86", { (err_no, err_msg) in
          blog.verbose((err_no, err_msg))
          if 0 == err_no {
            DispatchQueue.main.async {
              self.signup.title(title: L10n.signupSendVerifycode)
              self.verifyHeight.constant = 30
              self.signup.stopAnimation()
              self.countdownTimer.start()
            }
          }else {
            DispatchQueue.main.async {
              errorLocal.error(err_no: err_no, orMsg: err_msg)
              self.phoneno.isEnabled = true
              self.password.isEnabled = true
              self.password.isSecureTextEntry = false
              self.signup.stopAnimation()
            }
          }
        })
      }
    }else {
      if verifycode.text!.isEmpty {
        errorLocal.error(err_no: nil, orMsg: L10n.signupVerifiycoeLimit)
        return
      }
      netdbwarpper.sharedNetdb().regist(self.phoneno.text!, "86", self.password.text!, self.verifycode.text!, { (err_no, err_msg) in
        blog.verbose((err_no, err_msg))
        DispatchQueue.main.async {
          if 0 == err_no {
            errorLocal.success(msg: L10n.signupSuccess)
              //userinfo.change2barController()
            UIApplication.shared.delegate?.window??.rootViewController = StoryboardScene.Main.instantiateTabbarController()
          }else {
            errorLocal.error(err_no: err_no, orMsg: err_msg)
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
