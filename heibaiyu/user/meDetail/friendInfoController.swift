//
//  friendInfoController.swift
//  heibaiyu
//
//  Created by jiwei.wang on 3/10/17.
//  Copyright © 2017 yijian. All rights reserved.
//

import Foundation
import SDWebImage

class friendInfoController: UIViewController {
  @IBOutlet weak var icon: UIImageView!
  @IBOutlet weak var info: UILabel!
  @IBOutlet weak var sendMsg: UITextField!
  @IBOutlet weak var addfriend: IndicatorButton!
  
  var isNeedSendField = true
  @IBOutlet weak var fieldHeight: NSLayoutConstraint!
  
  var userid: String?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    KeyboardAvoiding.avoidingView = self.view
    self.navigationItem.leftBarButtonItems = [UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(backAction))]
    if isNeedSendField {
      fieldHeight.constant = 44
      sendMsg.text = L10n.friendSendQuery
      addfriend.addTarget(self, action: #selector(queryadd), for: .touchUpInside)
    }else {
      fieldHeight.constant = 0
      sendMsg.text = L10n.friendSendMsg
      addfriend.addTarget(self, action: #selector(sendMessage), for: .touchUpInside)
    }
    setUserinfo()
  }
  
  func backAction() {
    self.dismiss(animated: true, completion: nil)
  }
  
  func queryadd() {
    netdbwarpper.sharedNetdb().addFiend(userid!, sendMsg.text ?? "") { (errno, errmsg) in
      DispatchQueue.main.async {
        if 0 == errno {
          errorLocal.success(msg: L10n.success)
        }else {
          errorLocal.error(err_no: errno, orMsg: errmsg)
        }
      }
    }
  }
  
  func sendMessage() {
    self.dismiss(animated: false) { [weak self] in
      NotificationCenter.default.post(name: notificationName.talk2user, object: self, userInfo: [notificationName.talk2user_key_userid: self?.userid ?? ""])
    }
  }
  
  func setUserinfo() {
    if let data = netdbwarpper.sharedNetdb().dbGetUser(userid!) {
      let user = try? Chat_User(protobuf: data)
      if let path = user?.icon {
        icon.sd_setImage(with: URL(string: String.http(relativePath: path)), placeholderImage: #imageLiteral(resourceName: "placeholderimage"))
      }
      var infos: String = ""
      if let nickname = user?.nickname {
        infos += nickname + "\n"
      }
      let gender = (user?.isMale)! ? L10n.userGenderMale : L10n.userGenderFemale
      infos += gender + "\n"
      if let desc = user?.description_p {
        infos += desc
      }
      info.text = infos
    }
  }
}

extension friendInfoController: UIScrollViewDelegate {
  func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
    self.sendMsg.resignFirstResponder()
  }
}



