import SwiftUI

// ========================================================================
// MARK: TextStyleBuilder
// This layer is used to get the availability to define static properties to list all your styles.
// It's only a factory function for building your style class from the given theme.
// ========================================================================

public struct TextStyleBuilder<
  Color: ColorProvider, FontKey: Hashable, Geometry: GeometryProvider, VM: ViewModifier
> {
  public typealias BuildStyle = (Theme<Color, FontKey, Geometry>) -> VM

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
  public func text<VM: ViewModifier>(_ builder: TextStyleBuilder<Color, FontKey, Geometry, VM>) -> VM {
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

// ========================================================================
// MARK: SwiftUI extension API to avoid
// This API is used to be consistent with SwiftUI APIs like ButtonStyle
// ========================================================================

extension View {
  public func textStyle<Color, FontKey, Geometry, VM>(
    _ builder: TextStyleBuilder<Color, FontKey, Geometry, VM>
  ) -> some View {
    modifier(TextStyleShortModifier(textStyleBuilder: builder))
  }
}
private struct TextStyleShortModifier<Color: ColorProvider, FontKey: Hashable, Geometry: GeometryProvider, VM: ViewModifier>: ViewModifier {
  @EnvironmentObject var theme: Theme<Color, FontKey, Geometry>
  let textStyleBuilder: TextStyleBuilder<Color, FontKey, Geometry, VM>
  
  func body(content: Content) -> some View {
    content.textStyle(theme.text(textStyleBuilder))
  }
}
