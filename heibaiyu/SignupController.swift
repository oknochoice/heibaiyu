//
//  SignupController.swift
//  heibaiyu
//
//  Created by jiwei.wang on 1/20/17.
//  Copyright © 2017 yijian. All rights reserved.
//

import UIKit
import Eureka
import PhoneNumberKit

class SignupController: FormViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        form = form
            +++ Section(header: "输入你的手机号", footer: "目前限定中国+86号段")
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
