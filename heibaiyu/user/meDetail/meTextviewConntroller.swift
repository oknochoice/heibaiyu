
//
//  meTextviewConntroller.swift
//  heibaiyu
//
//  Created by jiwei.wang on 3/9/17.
//  Copyright © 2017 yijian. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class meTextviewController: UIViewController {
  var text: String?
  
  var save:((_ text: String, _ success: @escaping (() -> Void)) -> Void)?
  
  let disposeBag = DisposeBag()
  
  @IBOutlet weak var textview: UITextView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    textview.layer.borderWidth = 0.5
    textview.layer.borderColor = Color.black.cgColor
    textview.layer.cornerRadius = 4
    textview.text = text
    textview.textContainerInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
    textview.becomeFirstResponder()
    
    let rightButton = UIBarButtonItem(barButtonSystemItem: .save, target: nil, action: nil )
    self.navigationItem.rightBarButtonItem = rightButton
    rightButton.rx.tap.subscribe(onNext: {[weak self] in
      if let save = self?.save {
        save((self?.textview.text!)!, {
          let _ = self?.navigationController?.popViewController(animated: true)
        })
      }
    }).disposed(by: disposeBag)
    
    textview.rx.text.orEmpty.map { (text) -> Bool in
      return text.characters.count < 100 && text.characters.count > 0
    }.map { (isLengthValid) -> Color in
      return isLengthValid ? Color.black : Color.red
    }.subscribe(onNext: {[weak self] (color) in
      self?.textview.textColor = color
    }).disposed(by: disposeBag)
  }
  
  deinit {
    blog.verbose()
  }
}
