// Generated using SwiftGen, by O.Halligon — https://github.com/AliSoftware/SwiftGen

import Foundation

// swiftlint:disable file_length
// swiftlint:disable line_length

// swiftlint:disable type_body_length
// swiftlint:disable nesting
// swiftlint:disable variable_name
// swiftlint:disable valid_docs

enum L10n {
  /// 取消
  static let cancel = L10n.tr("cancel")
  /// 已同意
  static let friendAddAuthorized = L10n.tr("friend_add_authorized")
  /// 添加请求已发送
  static let friendAddQuerySended = L10n.tr("friend_add_query_sended")
  /// 好友请求
  static let friendInfoQuerys = L10n.tr("friend_info_querys")
  /// 发消息
  static let friendSendMsg = L10n.tr("friend_send_msg")
  /// 发送
  static let friendSendQuery = L10n.tr("friend_send_query")
  /// 添加
  static let friendStatusAdd = L10n.tr("friend_status_add")
  /// 已添加
  static let friendStatusAdded = L10n.tr("friend_status_added")
  /// 同意
  static let friendStatusAuthorize = L10n.tr("friend_status_authorize")
  /// 输入一条消息
  static let messageChatInputPlaceholdertext = L10n.tr("message_chat_input_placeholdertext")
  /// 发送
  static let messageChatInputSend = L10n.tr("message_chat_input_send")
  /// 相册
  static let photoLocal = L10n.tr("photo_local")
  /// 保存至相册
  static let photoSaveAlbum = L10n.tr("photo_save_album")
  /// 保存图片失败
  static let photoSaveFailure = L10n.tr("photo_save_failure")
  /// 保存图片成功
  static let photoSaveSuccess = L10n.tr("photo_save_success")
  /// 图片上传中
  static let photoUpload = L10n.tr("photo_upload")
  /// 图片上传失败
  static let photoUploadFailure = L10n.tr("photo_upload_failure")
  /// 图片上传成功
  static let photoUploadSuccess = L10n.tr("photo_upload_success")
  /// 添加好友
  static let searchAddFriend = L10n.tr("search_addFriend")
  /// 网络查找手机号
  static let searchFriendTip = L10n.tr("search_friend_tip")
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
  /// 成功
  static let success = L10n.tr("success")
  /// 生日:
  static let userBirthday = L10n.tr("user_birthday")
  /// 个性签名:
  static let userDesc = L10n.tr("user_desc")
  /// 性别:
  static let userGender = L10n.tr("user_gender")
  /// 女
  static let userGenderFemale = L10n.tr("user_gender_female")
  /// 男
  static let userGenderMale = L10n.tr("user_gender_male")
  /// 头像:
  static let userIcon = L10n.tr("user_icon")
  /// 头像
  static let userIconTitle = L10n.tr("user_icon_title")
  /// 个人信息
  static let userInfoTitle = L10n.tr("user_info_title")
  /// 退出
  static let userLogout = L10n.tr("user_logout")
  /// 昵称:
  static let userNickname = L10n.tr("user_nickname")
  /// 姓名:
  static let userRealname = L10n.tr("user_realname")
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

