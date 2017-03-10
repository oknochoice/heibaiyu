//
//  meTextfieldController.swift
//  heibaiyu
//
//  Created by jiwei.wang on 3/2/17.
//  Copyright © 2017 yijian. All rights reserved.
//

import Foundation

class meTextfieldController: UIViewController {
  
  var text: String?
  
  var save:((_ text: String, _ success: @escaping (() -> Void)) -> Void)?
  
  @IBOutlet weak var textfield: UITextField!
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    textfield.text = text
    textfield.becomeFirstResponder()
    
    let rightButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(rightTap))
    self.navigationItem.rightBarButtonItem = rightButton
    
    NotificationCenter.default.addObserver(self, selector: #selector(changeColor), name: .UITextFieldTextDidChange, object: textfield)
    
  }
  
  func changeColor() {
    if let length = textfield.text?.characters.count {
      if length < 15 && length > 0 {
        textfield.textColor = Color.black
      }else {
        textfield.textColor = Color.red
      }
    }
  }
  
  func rightTap() {
    if let save = self.save {
      save((self.textfield.text!), {
        let _ = self.navigationController?.popViewController(animated: true)
      })
    }
  }
  
  deinit {
    blog.verbose()
  }
  
}
