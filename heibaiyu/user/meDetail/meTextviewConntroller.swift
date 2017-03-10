
//
//  meTextviewConntroller.swift
//  heibaiyu
//
//  Created by jiwei.wang on 3/9/17.
//  Copyright © 2017 yijian. All rights reserved.
//

import Foundation

class meTextviewController: UIViewController {
  var text: String?
  
  var save:((_ text: String, _ success: @escaping (() -> Void)) -> Void)?
  
  @IBOutlet weak var textview: UITextView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    textview.layer.borderWidth = 0.5
    textview.layer.borderColor = Color.black.cgColor
    textview.layer.cornerRadius = 4
    textview.text = text
    textview.textContainerInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
    textview.becomeFirstResponder()
    
    let rightButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(rightTap))
    self.navigationItem.rightBarButtonItem = rightButton
    
    NotificationCenter.default.addObserver(self, selector: #selector(changeColor), name: .UITextViewTextDidChange, object: textview)
    
  }
  
  func rightTap() {
    if let save = self.save {
      save((self.textview.text!), {
        let _ = self.navigationController?.popViewController(animated: true)
      })
    }
  }
  
  func changeColor() {
    if let length = textview.text?.characters.count {
      if length < 100 && length > 0 {
        textview.textColor = Color.black
      }else {
        textview.textColor = Color.red
      }
    }
  }
  
  deinit {
    blog.verbose()
  }
}


