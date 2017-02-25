//
//  meIconController.swift
//  heibaiyu
//
//  Created by jiwei.wang on 2/23/17.
//  Copyright © 2017 yijian. All rights reserved.
//

import Foundation
import SnapKit

class meIconController: baseViewController, FusumaDelegate {
  var icon: UIImage?
  
  @IBOutlet weak var imageview: imageScroll!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.title = L10n.userIconTitle
    self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "...", style: .plain, target: self, action: #selector(sheetTip))
  }
  deinit {
    blog.verbose()
  }
  
  func sheetTip() {
    let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
    alert.addAction(UIAlertAction(title: L10n.photoSave, style: .default, handler: {[weak self] (action) in
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
