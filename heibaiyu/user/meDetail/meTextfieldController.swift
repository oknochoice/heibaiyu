//
//  meTextfieldController.swift
//  heibaiyu
//
//  Created by jiwei.wang on 3/2/17.
//  Copyright © 2017 yijian. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class meTextfieldController: UIViewController {
  
  var text: String?
  
  var save:((_ text: String) -> Void)?
  
  let disposeBag = DisposeBag()
  @IBOutlet weak var textfield: UITextField!
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    textfield.text = text
    
    let rightButton = UIBarButtonItem(barButtonSystemItem: .save, target: nil, action: nil )
    self.navigationItem.rightBarButtonItem = rightButton
    rightButton.rx.tap.subscribe(onNext: {[weak self] in
      if let save = self?.save {
        save((self?.textfield.text)!)
      }
    }).disposed(by: disposeBag)
    
    textfield.rx.text.orEmpty.map { (text) -> Bool in
      return text.characters.count < 15 && text.characters.count > 0
    }.map { (isLengthValid) -> Color in
      return isLengthValid ? Color.black : Color.red
    }.subscribe(onNext: {[weak self] (color) in
      self?.textfield.textColor = color
    }).disposed(by: disposeBag)
  }
  
}
