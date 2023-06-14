import SwiftUI

// ========================================================================
// MARK: ButtonStyleBuilder
// This layer is used to get the availability to define static properties to list all your styles.
// It's only a factory function for building your style class from the given theme.
// ========================================================================

public struct ButtonStyleBuilder<
  ColorKey: Hashable, FontKey: Hashable, SpacingKey: Hashable, BS: ButtonStyle
> {
  public typealias BuildStyle = (Theme<ColorKey, FontKey, SpacingKey>) -> BS

  let buildStyle: BuildStyle

  public static func buildStyle(_ buildStyle: @escaping BuildStyle) -> Self {
    .init(buildStyle: buildStyle)
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
  public func button<BS>(_ builder: ButtonStyleBuilder<ColorKey, FontKey, SpacingKey, BS>) -> BS
  where BS: ButtonStyle {
    builder.buildStyle(self)
  }
}
