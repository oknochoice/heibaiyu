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
    }

  @IBAction func signin(_ sender: IndicatorButton) {
    var device = Chat_Device()
    device.os = Chat_Device.OperatingSystem.iOs
    device.deviceModel = Device.version().rawValue
    device.uuid = UUID().uuidString
    var signin = Chat_Login()
    signin.countryCode = "86"
    signin.phoneNo = phoneno.text!
    signin.password = password.text!
    signin.device = device
    do {
      let data = try signin.serializeProtobuf()
      netyiwarpper.netyi_signup_login_connect(with: ChatType.login.rawValue, data: String(data: data, encoding: .utf8)!, cb: { (type, sdata, isStop) in
        
      })
    } catch {
      blog.debug(error)
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
