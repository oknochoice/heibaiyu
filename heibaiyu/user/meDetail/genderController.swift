//
//  meRadioCheckController.swift
//  heibaiyu
//
//  Created by jiwei.wang on 3/9/17.
//  Copyright © 2017 yijian. All rights reserved.
//

import Foundation

class genderController: settingBaseController {
  
  var isMale: Bool?
  
  override func viewDidLoad() {
    super.viewDidLoad()
      genderGen()
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    super.tableView(tableView, didSelectRowAt: indexPath)
    genderCellDidSelect(indexPath.row)
  }
  
  
  
  func genderCellDidSelect(_ row: Int) {
    var isMale = false
    if row == 0 {
      isMale = true
    }
    netdbwarpper.sharedNetdb().setUserIsmale(isMale) { (errno, errmsg) in
      DispatchQueue.main.async {
        if errno == 0 {
          errorLocal.success(msg: L10n.success)
          if let cellmodel = self.tableDatas![0].cellModels![row] as? settingRadioCellModel {
            cellmodel.setRadioed()
          }
          
          let _ = self.navigationController?.popViewController(animated: true)
        }else{
          errorLocal.error(err_no: errno, orMsg: errmsg)
        }
      }
    }
  }
  
  func genderGen() {
    // gender section
    let section = settingRadioSectionModel()
    // male cell
    let male = settingRadioCellModel()
    male.cellIdentifier = "settingRadio"
    male.title = L10n.userGenderMale
    male.isRadioed = isMale! ? true : false
    male.section = section
    // female 
    let female = settingRadioCellModel()
    female.cellIdentifier = "settingRadio"
    female.title = L10n.userGenderFemale
    female.isRadioed = isMale! ? false : true
    female.section = section
    
    section.cellModels = [male, female]
    
    self.tableDatas = [section]
    self.tableview.reloadData()
  }
  
}
