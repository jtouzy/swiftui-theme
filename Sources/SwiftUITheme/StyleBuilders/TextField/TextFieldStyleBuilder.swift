import SwiftUI

// ========================================================================
// MARK: TextFieldStyleBuilder
// This layer is used to get the availability to define static properties to list all your styles.
// It's only a factory function for building your style class from the given theme.
// ========================================================================

public struct TextFieldStyleBuilder<
  ColorKey: Hashable, FontKey: Hashable, SpacingKey: Hashable, TFS: TextFieldStyle
> {
  public typealias BuildStyle = (Theme<ColorKey, FontKey, SpacingKey>) -> TFS

  let buildStyle: BuildStyle

  public static func buildStyle(_ buildStyle: @escaping BuildStyle) -> Self {
    .init(buildStyle: buildStyle)
  }
}

// ========================================================================
// MARK: Theme API
// This API must be exposed to allow TextFieldStyle creation based on a theme in SwiftUI views.
// ========================================================================

extension Theme {
  /// Theme-styled Button API.
  /// - Parameter builder: Builder used to construct the related ButtonStyle.
  /// - Returns: A ButtonStyle created based on the builder definition.
  public func textField<T>(_ builder: TextFieldStyleBuilder<ColorKey, FontKey, SpacingKey, T>) -> T
  where T: TextFieldStyle {
    builder.buildStyle(self)
  }
}
