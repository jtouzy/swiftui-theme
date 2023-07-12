import SwiftUI

// ========================================================================
// MARK: TextEditorStyleBuilder
// This layer is used to get the availability to define static properties to list all your styles.
// It's only a factory function for building your style class from the given theme.
// ========================================================================

public struct TextEditorStyleBuilder<
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
  public func textEditorStyle<Color, FontKey, Constant, VM>(
    _ builder: TextEditorStyleBuilder<Color, FontKey, Constant, VM>
  ) -> some View {
    modifier(TextEditorStyleApplierModifier(textStyleBuilder: builder))
  }
}

private struct TextEditorStyleApplierModifier<Color, FontKey, Constant, VM>: ViewModifier
where Color: ColorProvider, FontKey: Hashable, Constant: ConstantProvider, VM: ViewModifier {
  @EnvironmentObject var theme: Theme<Color, FontKey, Constant>
  let textStyleBuilder: TextEditorStyleBuilder<Color, FontKey, Constant, VM>
  
  func body(content: Content) -> some View {
    content.modifier(textStyleBuilder.buildStyle(theme))
  }
}
