import SwiftUI

// ========================================================================
// MARK: ButtonStyleBuilder
// This layer is used to get the availability to define static properties to list all your styles.
// It's only a factory function for building your style class from the given theme.
// ========================================================================

public struct ButtonStyleBuilder<
  Color: ColorProvider, FontKey: Hashable, Constant: ConstantProvider, BS: ButtonStyle
> {
  public typealias BuildStyle = (Theme<Color, FontKey, Constant>) -> BS

  let buildStyle: BuildStyle

  public static func buildStyle(_ buildStyle: @escaping BuildStyle) -> Self {
    .init(buildStyle: buildStyle)
  }
}

// ========================================================================
// MARK: SwiftUI extension API
// This API is used to be consistent with SwiftUI APIs
// ========================================================================

extension View {
  public func buttonStyle<Color, FontKey, Constant, BS>(
    _ builder: ButtonStyleBuilder<Color, FontKey, Constant, BS>
  ) -> some View {
    modifier(ButtonStyleApplierModifier(buttonStyleBuilder: builder))
  }
}

private struct ButtonStyleApplierModifier<Color, FontKey, Constant, BS>: ViewModifier
where Color: ColorProvider, FontKey: Hashable, Constant: ConstantProvider, BS: ButtonStyle {
  @EnvironmentObject var theme: Theme<Color, FontKey, Constant>
  let buttonStyleBuilder: ButtonStyleBuilder<Color, FontKey, Constant, BS>
  
  func body(content: Content) -> some View {
    content.buttonStyle(buttonStyleBuilder.buildStyle(theme))
  }
}
