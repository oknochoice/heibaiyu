//
//  meIconController.swift
//  heibaiyu
//
//  Created by jiwei.wang on 2/23/17.
//  Copyright © 2017 yijian. All rights reserved.
//

import Foundation
import SnapKit
import Whisper

class meIconController: baseViewController, FusumaDelegate{
  var icon: UIImage?
  
  @IBOutlet weak var imageview: imageScroll!
  
  var iconpath: String?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.title = L10n.userIconTitle
    let detail = UIBarButtonItem(title: "...", style: .plain, target: self, action: #selector(sheetTip))
    self.navigationItem.rightBarButtonItems = [detail]
    
    if let ipath = iconpath {
      let m = phMedia(imageurl: ipath)
      imageview.media = m
    }
  }
  
  deinit {
    blog.verbose()
  }
  
  func sheetTip() {
    let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
    alert.addAction(UIAlertAction(title: L10n.photoSaveAlbum, style: .default, handler: {[weak self] (action) in
      blog.verbose("save image")
      PHPhotoLibrary.shared().performChanges({
        if let image = self?.icon {
          PHAssetCreationRequest.creationRequestForAsset(from: image)
        }else{
          blog.error()
        }
      }, completionHandler: { (isSuccess, error) in
        if isSuccess {
          errorLocal.success(msg: L10n.photoSaveSuccess)
        }else if let error = error {
          errorLocal.error(err_no: nil, orMsg: error.localizedDescription)
        }else {
          blog.error()
        }
      })
    }))
    alert.addAction(UIAlertAction(title: L10n.photoLocal, style: .default, handler: { (action) in
      blog.verbose("photo camera")
      let fusuma = FusumaViewController()
      fusuma.delegate = self
      fusuma.hasVideo = false
      self.present(fusuma, animated: true, completion: nil)
    }))
    alert.addAction(UIAlertAction(title: L10n.cancel, style: .cancel, handler: nil))
    self.present(alert, animated: true, completion: nil)
  }

  //MARK: - fusuma delegate
  func fusumaImageSelected(_ image: UIImage, source: FusumaMode) {
    let m = phMedia(image: image)
    self.imageview.media = m
    let mur = Murmur(title: L10n.photoUpload, backcolor: #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1))
    Whisper.show(whistle: mur)
    let up = UpYun()
    up.upload(image: image, success: { (savekey, urlRes, data) in
      netdbwarpper.sharedNetdb().setUserIcon(savekey, { (err_no, err_msg) in
        DispatchQueue.main.async {
          if 0 == err_no {
            let mur = Murmur(title: L10n.photoUploadSuccess, backcolor: #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1))
            Whisper.show(whistle: mur)
          }else {
            errorLocal.error(err_no: err_no, orMsg: err_msg)
          }
        }
      })
    }, failure: { (error) in
      let mur = Murmur(title: L10n.photoUploadFailure, backcolor: #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1))
      Whisper.show(whistle: mur)
    }) { (percent, sendAlready) in
      blog.verbose("percent: \(percent)")
    }
  }
  
  func fusumaVideoCompleted(withFileURL fileURL: URL) {
    
  }
  
  func fusumaCameraRollUnauthorized() {
    
  }
  
  func fusumaDismissedWithImage(_ image: UIImage, source: FusumaMode) {
    
  }
  
  func fusumaClosed() {
    
  }
  
  func fusumaWillClosed() {
  }

}
