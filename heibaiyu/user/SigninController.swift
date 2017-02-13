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
  
  @IBOutlet weak var signinButton: IndicatorButton!
    override func viewDidLoad() {
      super.viewDidLoad()

      // Do any additional setup after loading the view.
      signinButton.greenbackWhiteword()
      signinButton.title(title: L10n.signinSignin)
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
    sender.startAnimation()
    netdbwarpper.sharedNetdb().login(self.phoneno.text!, "86", self.password.text!, { (err_no, err_msg) in
      blog.verbose((err_no, err_msg))
      DispatchQueue.main.async {
        if 0 == err_no {
          errorLocal.success(msg: "connect success");
          UIApplication.shared.delegate?.window??.rootViewController = StoryboardScene.Main.instantiateTabbarController()
        }else {
          sender.stopAnimation()
          errorLocal.error(err_no: err_no, orMsg: err_msg)
        }
      }
    });
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
