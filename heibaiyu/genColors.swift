// Generated using SwiftGen, by O.Halligon — https://github.com/AliSoftware/SwiftGen

#if os(iOS) || os(tvOS) || os(watchOS)
  import UIKit.UIColor
  typealias Color = UIColor
#elseif os(OSX)
  import AppKit.NSColor
  typealias Color = NSColor
#endif

extension Color {
  convenience init(rgbaValue: UInt32) {
    let red   = CGFloat((rgbaValue >> 24) & 0xff) / 255.0
    let green = CGFloat((rgbaValue >> 16) & 0xff) / 255.0
    let blue  = CGFloat((rgbaValue >>  8) & 0xff) / 255.0
    let alpha = CGFloat((rgbaValue      ) & 0xff) / 255.0

    self.init(red: red, green: green, blue: blue, alpha: alpha)
  }
}

// swiftlint:disable file_length
// swiftlint:disable line_length

// swiftlint:disable type_body_length
enum ColorName {
  /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#1aae2c"></span>
  /// Alpha: 100% <br/> (0x1aae2cff)
  case congqian
  /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#02245e"></span>
  /// Alpha: 100% <br/> (0x02245eff)
  case huaqin
  /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#627686"></span>
  /// Alpha: 100% <br/> (0x627686ff)
  case mohui
  /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#169534"></span>
  /// Alpha: 100% <br/> (0x169534ff)
  case qincong
  /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#fda819"></span>
  /// Alpha: 100% <br/> (0xfda819ff)
  case tenghuang
  /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#4e1e16"></span>
  /// Alpha: 100% <br/> (0x4e1e16ff)
  case xuanqin

  var rgbaValue: UInt32 {
    switch self {
    case .congqian:
      return 0x1aae2cff
    case .huaqin:
      return 0x02245eff
    case .mohui:
      return 0x627686ff
    case .qincong:
      return 0x169534ff
    case .tenghuang:
      return 0xfda819ff
    case .xuanqin:
      return 0x4e1e16ff
    }
  }

  var color: Color {
    return Color(named: self)
  }
}
// swiftlint:enable type_body_length

extension Color {
  convenience init(named name: ColorName) {
    self.init(rgbaValue: name.rgbaValue)
  }
}

