import SwiftUI

// ========================================================================
// MARK: TextFieldStyleBuilder
// This layer is used to get the availability to define static properties to list all your styles.
// It's only a factory function for building your style class from the given theme.
// ========================================================================

public struct TextFieldStyleBuilder<
  Color: ColorProvider, FontKey: Hashable, Constant: ConstantProvider, TFS: TextFieldStyle
> {
  public typealias BuildStyle = (Theme<Color, FontKey, Constant>) -> TFS

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
  public func textFieldStyle<Color, FontKey, Constant, TFS>(
    _ builder: TextFieldStyleBuilder<Color, FontKey, Constant, TFS>
  ) -> some View {
    modifier(TextFieldStyleApplierModifier(textFieldStyleBuilder: builder))
  }
}

private struct TextFieldStyleApplierModifier<Color, FontKey, Constant, TFS>: ViewModifier
where Color: ColorProvider, FontKey: Hashable, Constant: ConstantProvider, TFS: TextFieldStyle {
  @EnvironmentObject var theme: Theme<Color, FontKey, Constant>
  let textFieldStyleBuilder: TextFieldStyleBuilder<Color, FontKey, Constant, TFS>
  
  func body(content: Content) -> some View {
    content.textFieldStyle(textFieldStyleBuilder.buildStyle(theme))
  }
}
