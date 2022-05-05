import SwiftUITheme
import SwiftUI

// ========================================================================

// MARK: DesignSystem colors
extension Theme.ColorKey {
  static let primary: Self = "Primary"
}

// MARK: DesignSystem fonts
extension Theme.FontKey {
  static let primary: Self = "Roboto"
}

// ========================================================================

// MARK: DesignSystem for buttons
extension ButtonStyleBuilder where BS == MyPrimaryButtonStyle {
  static let primary: Self = .init {
    .init(theme: $0)
  }
}
struct MyPrimaryButtonStyle: ButtonStyle {
  let theme: Theme

  func makeBody(configuration: Configuration) -> some View {
    configuration
      .label
      .padding(16.0)
      .background(RoundedRectangle(cornerRadius: 14.0).fill(theme.color(.primary)))
      .scaleEffect(configuration.isPressed ? 0.98 : 1)
  }
}

// ========================================================================

// MARK: DesignSystem for texts
extension TextStyleBuilder where VM == DefaultTextViewModifier {
  static let bigBold: Self = .init {
    .init(theme: $0, font: .primary, textStyle: .title, foregroundColor: .primary)
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
      .font(theme.font(.default, style: fontStyle))
      .foregroundColor(theme.color(.primary))
  }
}
