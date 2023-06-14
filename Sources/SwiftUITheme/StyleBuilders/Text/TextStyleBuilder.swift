import SwiftUI

// ========================================================================
// MARK: TextStyleBuilder
// This layer is used to get the availability to define static properties to list all your styles.
// It's only a factory function for building your style class from the given theme.
// ========================================================================

public struct TextStyleBuilder<
  ColorKey: Hashable, FontKey: Hashable, SpacingKey: Hashable, VM: ViewModifier
> {
  public typealias BuildStyle = (Theme<ColorKey, FontKey, SpacingKey>) -> VM

  let buildStyle: BuildStyle

  public static func buildStyle(_ buildStyle: @escaping BuildStyle) -> Self {
    .init(buildStyle: buildStyle)
  }
}

// ========================================================================
// MARK: Theme API
// This API must be exposed to allow ViewModifier creation based on a theme in SwiftUI views.
// ========================================================================

extension Theme {
  /// Theme-styled Text API.
  /// - Parameter builder: Builder used to construct the related text ViewModifier.
  /// - Returns: A ViewModifier created based on the builder definition.
  public func text<VM: ViewModifier>(_ builder: TextStyleBuilder<ColorKey, FontKey, SpacingKey, VM>) -> VM {
    builder.buildStyle(self)
  }
}

// ========================================================================
// MARK: SwiftUI
// This API is used to be consistent with SwiftUI APIs like ButtonStyle
// ========================================================================

extension View {
  public func textStyle<VM>(_ viewModifier: VM) -> some View where VM: ViewModifier {
    modifier(viewModifier)
  }
}
