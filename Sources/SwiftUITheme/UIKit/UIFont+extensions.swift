#if canImport(UIKit)
import UIKit

extension UIFont {
  static func register(from url: URL) {
    guard
      let fontDataProvider = CGDataProvider(url: url as CFURL),
      let font = CGFont(fontDataProvider)
    else {
      return
    }
    var error: Unmanaged<CFError>?
    CTFontManagerRegisterGraphicsFont(font, &error)
  }
}
#endif
