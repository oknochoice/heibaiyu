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
  
  var nodeids_waiting: [String] = []
  var isWaiting: Bool = true
  
  var tabledatas:[messageModel] = []
  override func viewDidLoad() {
    super.viewDidLoad()
    tableview.rowHeight = 64
    NotificationCenter.default.addObserver(self, selector: #selector(push2user(noti:)), name: notificationName.talk2user, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(push2nodeids(noti:)), name: notificationName.updateOneMsg, object: nil)
    loadmessages()
  }
  
  func loadmessages() {
    // load data
    tabledatas = []
    for obj in userCurrent.getTalklist() {
      let model = messageModel.instance(tonodeid: obj)
      tabledatas.append(model)
    }
    tableview.reloadData()
    isWaiting = false
    updateMsg()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.tabBarController?.tabBar.isHidden = false
  }
  
  func push2nodeids(noti: Notification) {
    if let nodeid = noti.userInfo?[notificationName.updateOneMsg_key_nodeid] as? String {
      nodeids_waiting.append(nodeid)
      updateMsg()
    }
  }
  
  func updateMsg() {
    while !nodeids_waiting.isEmpty {
      if !isWaiting {
        updateOneMsg(nodeid: nodeids_waiting.first!)
        nodeids_waiting.removeFirst()
      }else{
        return
      }
    }
  }
  
  func push2user(noti: Notification) {
    self.tabBarController?.selectedIndex = 0
    if let userid = noti.userInfo?[notificationName.talk2user_key_userid] as? String {
      blog.verbose("push to userid " + userid)
      let user = userCurrent.shared()
      var tonodeid: String?
      for info in (user?.friends)! {
        if info.userId == userid {
          tonodeid = info.toNodeId
        }
      }
      if let id = tonodeid {
        let model = messageModel.instance(tonodeid: id)
        let controller = StoryboardScene.Chat.instantiateChatController()
        controller.model = model
        controller.delegates.addNodeid2Talk = {
          let nodeid = $0
          DispatchQueue.main.async { [weak self] in
            if let ss = self {
              ss.loadmessages()
            }
            var info = Chat_TalkInfo()
            info.toNodeId = model.tonodeid!
            if let uid = model.userid {
              info.toUserId = uid
            }
            userCurrent.putTalkinfo(info: info)
          }
        }
        self.navigationController?.pushViewController(controller, animated: true)
      }
    }
  }
  
  func updateOneMsg(nodeid:String) {
    
    if let index = tabledatas.index(where: { (model) -> Bool in
      model.tonodeid == nodeid
    }) {
      if index == 0 {
        let new = messageModel.instance(tonodeid: nodeid)
        tableview.beginUpdates()
        tabledatas[0] = new
        let indexpath = IndexPath(row: 0, section: 0)
        tableview.reloadRows(at: [indexpath], with: .none)
        tableview.endUpdates()
      }else {
        let new = messageModel.instance(tonodeid: nodeid)
        tableview.beginUpdates()
        tabledatas.remove(at: index)
        tabledatas.insert(new, at: 0)
        tableview.moveRow(at: IndexPath(row: index, section: 0), to: IndexPath(row: 0, section: 0))
        tableview.endUpdates()
      }
    } else {
      let new = messageModel.instance(tonodeid: nodeid)
      tableview.beginUpdates()
      tabledatas.insert(new, at: 0)
      tableview.insertRows(at: [IndexPath(row: 0, section: 0)], with: .top)
      tableview.endUpdates()
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
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let model = tabledatas[indexPath.row]
    let controller = StoryboardScene.Chat.instantiateChatController()
    controller.model = model
    self.navigationController?.pushViewController(controller, animated: true)
  }
  
  
}
