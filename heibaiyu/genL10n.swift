// Generated using SwiftGen, by O.Halligon — https://github.com/AliSoftware/SwiftGen

import Foundation

// swiftlint:disable file_length
// swiftlint:disable line_length

// swiftlint:disable type_body_length
// swiftlint:disable nesting
// swiftlint:disable variable_name
// swiftlint:disable valid_docs

enum L10n {
  /// 添加好友
  static let searchAddFriend = L10n.tr("search_addFriend")
  /// 登录
  static let signinSignin = L10n.tr("signin_signin")
  /// 获取验证码
  static let signupGetVerifycode = L10n.tr("signup_getVerifycode")
  /// 密码长度需>=6
  static let signupPasswordLimit = L10n.tr("signup_password_limit")
  /// 重新获取
  static let signupRegetVerifycode = L10n.tr("signup_regetVerifycode")
  /// 发送验证码
  static let signupSendVerifycode = L10n.tr("signup_sendVerifycode")
  /// 注册
  static let signupSignup = L10n.tr("signup_signup")
  /// 注册成功
  static let signupSuccess = L10n.tr("signup_success")
  /// 验证码长度需>=4
  static let signupVerifiycoeLimit = L10n.tr("signup_verifiycoe_limit")
}

extension L10n {
  fileprivate static func tr(_ key: String, _ args: CVarArg...) -> String {
    let format = NSLocalizedString(key, comment: "")
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

// swiftlint:enable type_body_length
// swiftlint:enable nesting
// swiftlint:enable variable_name
// swiftlint:enable valid_docs

