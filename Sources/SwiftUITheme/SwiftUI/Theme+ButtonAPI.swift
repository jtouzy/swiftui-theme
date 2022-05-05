import SwiftUI

// ========================================================================
// MARK: ButtonStyleBuilder
// This layer is used to get the availability to define static properties to list all your styles.
// It's only a factory function for building your style class from the given theme.
// ========================================================================

public struct ButtonStyleBuilder<BS: ButtonStyle> {
  public typealias BuildStyle = (Theme) -> BS

  public let buildStyle: BuildStyle

  public init(buildStyle: @escaping BuildStyle) {
    self.buildStyle = buildStyle
  }
}

// ========================================================================
// MARK: Theme API
// This API must be exposed to allow ButtonStyle creation based on a theme in SwiftUI views.
// ========================================================================

extension Theme {
  /// Theme-styled Button API.
  /// - Parameter builder: Builder used to construct the related ButtonStyle.
  /// - Returns: A ButtonStyle created based on the builder definition.
  public func button<BS>(_ builder: ButtonStyleBuilder<BS>) -> BS where BS: ButtonStyle {
    builder.buildStyle(self)
  }
}
