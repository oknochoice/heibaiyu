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
  
  @IBOutlet weak var textfield: UITextField!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    /*
    textfield.rx.text.orEmpty.map { (text) -> Bool in
      return text.characters.count < 15
    }.map { (isLengthValid) -> Color in
      return isLengthValid ? Color.black : Color.red
    }.subscribe(<#T##on: (Event<Color>) -> Void##(Event<Color>) -> Void#>)
 */
  }
  
}
