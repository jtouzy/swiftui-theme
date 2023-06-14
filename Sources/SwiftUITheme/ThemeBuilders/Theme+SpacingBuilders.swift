import SwiftUI

public protocol SpacingProvider {
  var spacing: CGFloat { get }
}

public extension SpacingProvider where Self: RawRepresentable, RawValue == CGFloat {
  var spacing: CGFloat { rawValue }
}
