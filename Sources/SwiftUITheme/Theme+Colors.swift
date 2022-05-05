import SwiftUI
#if canImport(UIKit)
import UIKit
#endif

extension Theme {
  public struct ColorKey: ExpressibleByStringLiteral, Hashable, Identifiable {
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
  public func color(_ key: ColorKey) -> SwiftUI.Color {
    Color(
      key.id,
      bundle: resourceBundle
    )
  }
}

#if canImport(UIKit)
extension Theme {
  public func uiColor(_ key: ColorKey) -> UIKit.UIColor? {
    UIColor(
      named: key.id,
      in: resourceBundle,
      compatibleWith: .none
    )
  }
}
#endif
