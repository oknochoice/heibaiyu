// Generated using SwiftGen, by O.Halligon — https://github.com/AliSoftware/SwiftGen

import Foundation
import UIKit
import heibaiyu

// swiftlint:disable file_length
// swiftlint:disable line_length
// swiftlint:disable type_body_length

protocol StoryboardSceneType {
  static var storyboardName: String { get }
}

extension StoryboardSceneType {
  static func storyboard() -> UIStoryboard {
    return UIStoryboard(name: self.storyboardName, bundle: nil)
  }

  static func initialViewController() -> UIViewController {
    guard let vc = storyboard().instantiateInitialViewController() else {
      fatalError("Failed to instantiate initialViewController for \(self.storyboardName)")
    }
    return vc
  }
}

extension StoryboardSceneType where Self: RawRepresentable, Self.RawValue == String {
  func viewController() -> UIViewController {
    return Self.storyboard().instantiateViewController(withIdentifier: self.rawValue)
  }
  static func viewController(identifier: Self) -> UIViewController {
    return identifier.viewController()
  }
}

protocol StoryboardSegueType: RawRepresentable { }

extension UIViewController {
  func perform<S: StoryboardSegueType>(segue: S, sender: Any? = nil) where S.RawValue == String {
    performSegue(withIdentifier: segue.rawValue, sender: sender)
  }
}

struct StoryboardScene {
  enum LaunchScreen: StoryboardSceneType {
    static let storyboardName = "LaunchScreen"
  }
  enum Main: String, StoryboardSceneType {
    static let storyboardName = "Main"

    static func initialViewController() -> UITabBarController {
      guard let vc = storyboard().instantiateInitialViewController() as? UITabBarController else {
        fatalError("Failed to instantiate initialViewController for \(self.storyboardName)")
      }
      return vc
    }

    case signinControllerScene = "SigninController"
    static func instantiateSigninController() -> heibaiyu.SigninController {
      guard let vc = StoryboardScene.Main.signinControllerScene.viewController() as? heibaiyu.SigninController
      else {
        fatalError("ViewController 'SigninController' is not of the expected class heibaiyu.SigninController.")
      }
      return vc
    }

    case signupControllerScene = "SignupController"
    static func instantiateSignupController() -> heibaiyu.SignupController {
      guard let vc = StoryboardScene.Main.signupControllerScene.viewController() as? heibaiyu.SignupController
      else {
        fatalError("ViewController 'SignupController' is not of the expected class heibaiyu.SignupController.")
      }
      return vc
    }

    case meControllerScene = "meController"
    static func instantiateMeController() -> heibaiyu.meController {
      guard let vc = StoryboardScene.Main.meControllerScene.viewController() as? heibaiyu.meController
      else {
        fatalError("ViewController 'meController' is not of the expected class heibaiyu.meController.")
      }
      return vc
    }

    case tabbarControllerScene = "tabbarController"
    static func instantiateTabbarController() -> UITabBarController {
      guard let vc = StoryboardScene.Main.tabbarControllerScene.viewController() as? UITabBarController
      else {
        fatalError("ViewController 'tabbarController' is not of the expected class UITabBarController.")
      }
      return vc
    }
  }
  enum MeDetail: String, StoryboardSceneType {
    static let storyboardName = "MeDetail"

    case addFriendInfolistControllerScene = "addFriendInfolistController"
    static func instantiateAddFriendInfolistController() -> heibaiyu.addFriendInfolistController {
      guard let vc = StoryboardScene.MeDetail.addFriendInfolistControllerScene.viewController() as? heibaiyu.addFriendInfolistController
      else {
        fatalError("ViewController 'addFriendInfolistController' is not of the expected class heibaiyu.addFriendInfolistController.")
      }
      return vc
    }

    case genderControllerScene = "genderController"
    static func instantiateGenderController() -> heibaiyu.genderController {
      guard let vc = StoryboardScene.MeDetail.genderControllerScene.viewController() as? heibaiyu.genderController
      else {
        fatalError("ViewController 'genderController' is not of the expected class heibaiyu.genderController.")
      }
      return vc
    }

    case meIconControllerScene = "meIconController"
    static func instantiateMeIconController() -> heibaiyu.meIconController {
      guard let vc = StoryboardScene.MeDetail.meIconControllerScene.viewController() as? heibaiyu.meIconController
      else {
        fatalError("ViewController 'meIconController' is not of the expected class heibaiyu.meIconController.")
      }
      return vc
    }

    case meTextfieldControllerScene = "meTextfieldController"
    static func instantiateMeTextfieldController() -> heibaiyu.meTextfieldController {
      guard let vc = StoryboardScene.MeDetail.meTextfieldControllerScene.viewController() as? heibaiyu.meTextfieldController
      else {
        fatalError("ViewController 'meTextfieldController' is not of the expected class heibaiyu.meTextfieldController.")
      }
      return vc
    }

    case meTextviewControllerScene = "meTextviewController"
    static func instantiateMeTextviewController() -> heibaiyu.meTextviewController {
      guard let vc = StoryboardScene.MeDetail.meTextviewControllerScene.viewController() as? heibaiyu.meTextviewController
      else {
        fatalError("ViewController 'meTextviewController' is not of the expected class heibaiyu.meTextviewController.")
      }
      return vc
    }
  }
  enum Search: String, StoryboardSceneType {
    static let storyboardName = "Search"

    case friendInfoControllerScene = "friendInfoController"
    static func instantiateFriendInfoController() -> heibaiyu.friendInfoController {
      guard let vc = StoryboardScene.Search.friendInfoControllerScene.viewController() as? heibaiyu.friendInfoController
      else {
        fatalError("ViewController 'friendInfoController' is not of the expected class heibaiyu.friendInfoController.")
      }
      return vc
    }

    case searchResultControllerScene = "searchResultController"
    static func instantiateSearchResultController() -> heibaiyu.searchResultController {
      guard let vc = StoryboardScene.Search.searchResultControllerScene.viewController() as? heibaiyu.searchResultController
      else {
        fatalError("ViewController 'searchResultController' is not of the expected class heibaiyu.searchResultController.")
      }
      return vc
    }
  }
}

struct StoryboardSegue {
}

