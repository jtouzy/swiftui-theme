import SwiftUI
#if canImport(UIKit)
import UIKit
#endif

extension Theme {
  public struct FontKey: ExpressibleByStringLiteral, Hashable, Identifiable {
    public typealias ID = String

    public let id: ID

    public init(stringLiteral value: String) {
      self = .init(id: value)
    }

    private init(id: ID) {
      self.id = id
    }
  }
}

extension Theme {
  public func font(
    _ key: FontKey,
    style: Font.TextStyle,
    weight: Font.Weight? = .none
  ) -> Font {
    fontManager.font(
      key: key,
      style: style,
      weight: weight
    )
  }
}

#if canImport(UIKit)
extension Theme {
  public func uiFont(
    _ key: FontKey,
    style: UIFont.TextStyle,
    weight: UIFont.Weight? = .none,
    handlesAccessibility: Bool = true
  ) -> UIFont? {
    fontManager.uiFont(
      key: key,
      style: style,
      weight: weight,
      handlesAccessibility: handlesAccessibility
    )
  }
}
#endif

extension Theme {
  func loadBundleFontsIfNeeded() {
    #if canImport(UIKit)
    guard let fontURLs = resourceBundle.urls(forResourcesWithExtension: "ttf", subdirectory: .none) else {
      return
    }
    fontURLs.forEach(UIFont.register(from:))
    #endif
  }
}
