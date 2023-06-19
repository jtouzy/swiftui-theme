import SwiftUI

public protocol ConstantProvider {
  var value: CGFloat { get }
}

public extension ConstantProvider where Self: RawRepresentable, RawValue == CGFloat {
  var value: CGFloat { rawValue }
}
