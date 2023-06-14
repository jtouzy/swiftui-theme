import SwiftUI

public protocol GeometryProvider {
  var value: CGFloat { get }
}

public extension GeometryProvider where Self: RawRepresentable, RawValue == CGFloat {
  var value: CGFloat { rawValue }
}
