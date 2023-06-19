import SwiftUI

// ========================================================================
// MARK: TextStyleBuilder
// This layer is used to get the availability to define static properties to list all your styles.
// It's only a factory function for building your style class from the given theme.
// ========================================================================

public struct TextStyleBuilder<
  Color: ColorProvider, FontKey: Hashable, Constant: ConstantProvider, VM: ViewModifier
> {
  public typealias BuildStyle = (Theme<Color, FontKey, Constant>) -> VM

  let buildStyle: BuildStyle

  public static func buildStyle(_ buildStyle: @escaping BuildStyle) -> Self {
    .init(buildStyle: buildStyle)
  }
}

// ========================================================================
// MARK: SwiftUI extension API
// This API is used to be consistent with SwiftUI APIs like ButtonStyle
// ========================================================================

extension View {
  public func textStyle<Color, FontKey, Constant, VM>(
    _ builder: TextStyleBuilder<Color, FontKey, Constant, VM>
  ) -> some View {
    modifier(TextStyleApplierModifier(textStyleBuilder: builder))
  }
}

private struct TextStyleApplierModifier<Color, FontKey, Constant, VM>: ViewModifier
where Color: ColorProvider, FontKey: Hashable, Constant: ConstantProvider, VM: ViewModifier {
  @EnvironmentObject var theme: Theme<Color, FontKey, Constant>
  let textStyleBuilder: TextStyleBuilder<Color, FontKey, Constant, VM>
  
  func body(content: Content) -> some View {
    content.modifier(textStyleBuilder.buildStyle(theme))
  }
}
