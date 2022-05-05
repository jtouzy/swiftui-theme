import SwiftUITheme
import SwiftUI

// ========================================================================

// MARK: DesignSystem colors
extension Theme.ColorKey {
  static let primary: Self = "Primary"
}

// MARK: DesignSystem fonts
extension Theme.FontKey {
  static let primary: Self = "San Francisco"
}

// ========================================================================

// MARK: DesignSystem for buttons


// ========================================================================

// MARK: DesignSystem for texts
extension TextStyleBuilder where VM == MyBigBoldPrimaryTextModifier {
  static let bigBold: Self = .init(buildStyle: MyBigBoldPrimaryTextModifier.init(theme:))
}
struct MyBigBoldPrimaryTextModifier: ViewModifier {
  let theme: Theme

  func body(content: Content) -> some View {
    content
      .font(theme.font(.primary, style: .title, weight: .bold))
      .foregroundColor(theme.color(.primary))
  }
}

// MARK: DesignSystem for texts with parameters
extension TextStyleBuilder where VM == MyCustomPrimaryTextModifier {
  static func customPrimary(size: Font.TextStyle) -> Self {
    .init { theme in
      MyCustomPrimaryTextModifier(theme: theme, fontStyle: size)
    }
  }
}
struct MyCustomPrimaryTextModifier: ViewModifier {
  let theme: Theme
  let fontStyle: Font.TextStyle

  func body(content: Content) -> some View {
    content
      .font(theme.font(.primary, style: fontStyle))
      .foregroundColor(theme.color(.primary))
  }
}
