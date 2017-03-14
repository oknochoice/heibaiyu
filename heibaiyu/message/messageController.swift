//
//  messageController.swift
//  heibaiyu
//
//  Created by yijian on 1/24/17.
//  Copyright © 2017 yijian. All rights reserved.
//

import UIKit

class messageController: UIViewController {

  @IBOutlet weak var tableview: UITableView!
  
  var tabledatas:[messageModel] = []
  override func viewDidLoad() {
      super.viewDidLoad()
    NotificationCenter.default.addObserver(self, selector: #selector(push2user(noti:)), name: notificationName.talk2user, object: nil)
    
    // load data
    let talklist_data = netdbwarpper.sharedNetdb().dbGet(netdbwarpper.sharedNetdb().dbkeyTalklist())
    if let data = talklist_data, let talklist = try? Chat_TalkList(protobuf: data) {
      for obj in talklist.talks {
        let model = messageModel()
        model.tonodeid = obj.toNodeId
        model.readedIncrement = obj.readedIncrement
        model.userid = obj.toUserId
        if obj.toUserId != "", let data = netdbwarpper.sharedNetdb().dbGetUser(obj.toUserId),
          let user = try? Chat_User(protobuf: data) {
          model.icon = String.http(relativePath: user.icon)
          model.name = String.getNonNil([user.nickname, user.realname, user.phoneNo])
        }else {
          if let data = netdbwarpper.sharedNetdb().dbGet(netdbwarpper.sharedNetdb().dbkeyMsgNode(obj.toNodeId)),
            let node = try? Chat_MessageNode(protobuf: data) {
            model.name = String.getNonNil([node.nickname, node.id])
          }
        }
        tabledatas.append(model)
      }
      tableview.reloadData()
    }
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.tabBarController?.tabBar.isHidden = false
  }
  
  func push2user(noti: Notification) {
    self.tabBarController?.selectedIndex = 0
    if let userid = noti.userInfo?[notificationName.talk2user_key_userid] as? String{
      blog.verbose("push to userid " + userid)
    }
  }
  
}

extension messageController: UITableViewDelegate, UITableViewDataSource {
  //MARK: - delegate datasource
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return tabledatas.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let model = tabledatas[indexPath.row]
    let cell = tableView.dequeueReusableCell(withIdentifier: "messageCell", for: indexPath)
    (cell as! messageCell).model = model
    return cell
  }
  
}
