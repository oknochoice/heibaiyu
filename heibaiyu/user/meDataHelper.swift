//
//  meDataHelper.swift
//  heibaiyu
//
//  Created by jiwei.wang on 2/28/17.
//  Copyright © 2017 yijian. All rights reserved.
//

import Foundation

class meModel {
  var title: String?
  var isRoot: Bool = false
  var sections: [settingSectionModel]?
  var reFreshList: ((Void) -> Void)?
}

extension meModel {
  
  static func me(vc: meController?) -> (() -> meModel ){
    let reCluture = {[weak vc] () -> meModel in
      
      let me = meModel()
      me.isRoot = true
      
      let user = userCurrent.shared()!
      
      // section me
      let meSModel = settingSectionModel()
      // cell me
      let meCModel = settingCellModel()
      meCModel.cellIdentifier = "settingLits_a"
      let from = user.phoneNo.index(user.phoneNo.endIndex, offsetBy: -4)
      meCModel.subTitle = "*** **** " + user.phoneNo.substring(from: from)
      var title = user.nickname
      if title.isEmpty {
        title = user.realname
      }
      if title.isEmpty {
        title = meCModel.subTitle!
      }
      meCModel.title = title
      meCModel.icon = String.http(relativePath: user.icon)
      meCModel.cellHeight = 66
      meCModel.tap = {
        if let pushvc = vc {
          let userinfovc = StoryboardScene.Main.instantiateMeController()
          userinfovc.modelGen = userinfo(vc: pushvc)
          pushvc.navigationController?.pushViewController(userinfovc, animated: true)
        }
      }
      meSModel.cellModels = [meCModel]
      
      // friend add info  Section
      let addfriendInfoSection = settingSectionModel()
      let addfriendCell = settingCellModel()
      addfriendCell.cellIdentifier = "settingLit_a"
      addfriendCell.title = L10n.friendInfoQuerys
      addfriendCell.tap = {
        if let pushvc = vc {
          let friendsQuerys = StoryboardScene.MeDetail.instantiateAddFriendInfolistController()
          pushvc.navigationController?.pushViewController(friendsQuerys, animated: true)
        }
      }
      addfriendInfoSection.cellModels = [addfriendCell]
      
      // quit section
      let quitSmodel = settingSectionModel()
      let quit = settingCellModel()
      quit.cellIdentifier = "settingCt"
      quit.title = L10n.userLogout
      quit.tap = {
        netdbwarpper.sharedNetdb().logout({ (errno, errmsg) in
          blog.verbose((errno, errmsg))
          DispatchQueue.main.async {
            let delegate = UIApplication.shared.delegate as! AppDelegate
            delegate.window?.rootViewController = StoryboardScene.Main.instantiateSigninController()
          }
        })
      }
      quitSmodel.cellModels = [quit]
      
      me.sections = [meSModel, addfriendInfoSection, quitSmodel]
      return me
    }
    return reCluture
  }
  
  static func userinfo(vc: meController?) -> (() -> meModel ) {
    let reClosure = { [weak vc] () -> meModel in
    
      let me = meModel()
      me.title = L10n.userInfoTitle
      
      let user = userCurrent.shared()!
      
      // section me
      let meSModel = settingSectionModel()
      // cell me
      let meCModel = settingCellModel()
      meCModel.cellIdentifier = "settingRit_a"
      meCModel.title = L10n.userIcon
      meCModel.icon = String.http(relativePath: user.icon)
      meCModel.tap = {[weak meCModel] in
        blog.verbose()
        if let pushvc = vc {
          let meicon = StoryboardScene.MeDetail.instantiateMeIconController()
          meicon.iconpath = meCModel?.icon
          pushvc.navigationController?.pushViewController(meicon, animated: true)
        }
      }
      // cell realname
      let realname = settingCellModel()
      realname.cellIdentifier = "settingts_a"
      realname.title = L10n.userRealname
      realname.subTitle = user.realname
      realname.tap = {
        if let pushvc = vc {
          let textfield = StoryboardScene.MeDetail.instantiateMeTextfieldController()
          textfield.text = user.realname
          textfield.save = { text, success in
            netdbwarpper.sharedNetdb().setUserRealname(text, { (errno, errmsg) in
              DispatchQueue.main.async {
                if errno == 0 {
                  errorLocal.success(msg: L10n.success)
                  success()
                }else {
                  errorLocal.error(err_no: errno, orMsg: errmsg)
                }
              }
            })
          }
          pushvc.navigationController?.pushViewController(textfield, animated: true)
        }
      }
      // cell nickname
      let nickname = settingCellModel()
      nickname.cellIdentifier = "settingts_a"
      nickname.title = L10n.userNickname
      nickname.subTitle = user.nickname
      nickname.tap = {
        if let pushvc = vc {
          let textfield = StoryboardScene.MeDetail.instantiateMeTextfieldController()
          textfield.text = user.nickname
          textfield.save = { text, success in
            netdbwarpper.sharedNetdb().setUserNickname(text, { (errno, errmsg) in
              DispatchQueue.main.async {
                if errno == 0 {
                  errorLocal.success(msg: L10n.success)
                  success()
                }else {
                  errorLocal.error(err_no: errno, orMsg: errmsg)
                }
              }
            })
          }
          pushvc.navigationController?.pushViewController(textfield, animated: true)
        }
      }
      // cell desc
      let desc = settingCellModel()
      desc.cellIdentifier = "settingts_a"
      desc.title = L10n.userDesc
      desc.subTitle = user.description_p
      desc.tap = {
        if let pushvc = vc {
          let textview = StoryboardScene.MeDetail.instantiateMeTextviewController()
          textview.text = user.description_p
          textview.save = { text, success in
            netdbwarpper.sharedNetdb().setUserDesc(text, { (errno, errmsg) in
              DispatchQueue.main.async {
                if errno == 0 {
                  errorLocal.success(msg: L10n.success)
                  success()
                }else {
                  errorLocal.error(err_no: errno, orMsg: errmsg)
                }
              }
            })
          }
          pushvc.navigationController?.pushViewController(textview, animated: true)
        }
      }
      // cell gender
      let gender = settingCellModel()
      gender.cellIdentifier = "settingts_a"
      gender.title = L10n.userGender
      gender.subTitle = user.isMale ? L10n.userGenderMale : L10n.userGenderFemale
      gender.tap = {
        if let pushvc = vc {
          let radio = StoryboardScene.MeDetail.instantiateGenderController()
          radio.isMale = user.isMale
          pushvc.navigationController?.pushViewController(radio, animated: true)
        }
      }
      
      
      // section
      meSModel.cellModels = [meCModel, realname, nickname, desc, gender]
      me.sections = [meSModel]
      return me
    }
    
    return reClosure
  }
  
}
