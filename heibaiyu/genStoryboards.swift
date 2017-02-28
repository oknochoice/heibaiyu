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

    case searchControllerScene = "searchController"
    static func instantiateSearchController() -> heibaiyu.searchController {
      guard let vc = StoryboardScene.Main.searchControllerScene.viewController() as? heibaiyu.searchController
      else {
        fatalError("ViewController 'searchController' is not of the expected class heibaiyu.searchController.")
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
  enum PhotoCamera: String, StoryboardSceneType {
    static let storyboardName = "PhotoCamera"

    case meIconControllerScene = "meIconController"
    static func instantiateMeIconController() -> heibaiyu.meIconController {
      guard let vc = StoryboardScene.PhotoCamera.meIconControllerScene.viewController() as? heibaiyu.meIconController
      else {
        fatalError("ViewController 'meIconController' is not of the expected class heibaiyu.meIconController.")
      }
      return vc
    }
  }
}

struct StoryboardSegue {
}

