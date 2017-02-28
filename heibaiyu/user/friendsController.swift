//
//  friendsController.swift
//  heibaiyu
//
//  Created by jiwei.wang on 1/24/17.
//  Copyright © 2017 yijian. All rights reserved.
//

import UIKit

class friendsController: baseViewController {

  override func viewDidLoad() {
    super.viewDidLoad()

    // Do any additional setup after loading the view.
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.tabBarController?.tabBar.isHidden = false
  }
  
  @IBAction func addFriend(_ sender: UIBarButtonItem) {
    self.navigationController?.pushViewController(StoryboardScene.Main.instantiateSearchController(), animated: true)
  }
    
  //MARK: - delegate datasource
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 0
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    return UITableViewCell()
  }

    /*
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  // MARK: - Navigation

  // In a storyboard-based application, you will often want to do a little preparation before navigation
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
  }
  */

}
