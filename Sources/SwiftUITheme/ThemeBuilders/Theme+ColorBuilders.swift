import SwiftUI

public protocol ColorProvider {
  var bundle: Bundle { get }
  var color: SwiftUI.Color { get }
}

public extension ColorProvider {
  var bundle: Bundle { .main }
}

public extension ColorProvider where Self: RawRepresentable, RawValue == String {
  var color: SwiftUI.Color { .init(rawValue, bundle: bundle) }
}
