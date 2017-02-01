// Generated using SwiftGen, by O.Halligon — https://github.com/AliSoftware/SwiftGen

import Foundation

// swiftlint:disable file_length
// swiftlint:disable line_length

// swiftlint:disable type_body_length
// swiftlint:disable nesting
// swiftlint:disable variable_name
// swiftlint:disable valid_docs

enum L10n {
  /// 获取验证码
  static let signupGetVerifycode = L10n.tr("signup_getVerifycode")
  /// 密码必须长度>=6
  static let signupPasswordLimit = L10n.tr("signup_password_limit")
  /// 重新获取
  static let signupRegetVerifycode = L10n.tr("signup_regetVerifycode")
  /// 发送验证码
  static let signupSendVerifycode = L10n.tr("signup_sendVerifycode")
  /// 注册
  static let signupSignup = L10n.tr("signup_signup")
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
