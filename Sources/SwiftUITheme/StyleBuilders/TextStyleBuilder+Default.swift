import SwiftUI

extension TextStyleBuilder where VM == DefaultTextStyleModifier<ColorKey, FontKey> {
  public static func styled(
    font fontKey: FontKey? = .none,
    as fontTextStyle: Font.TextStyle = .body,
    weight fontWeight: Font.Weight? = .none,
    foregroundColorKey: ColorKey? = .none
  ) -> Self {
    .init { theme in
      DefaultTextStyleModifier(
        theme: theme,
        configuration: .init(
          fontKey: fontKey,
          fontTextStyle: fontTextStyle,
          fontWeight: fontWeight,
          foregroundColorKey: foregroundColorKey
        )
      )
    }
  }
}
extension TextStyleBuilder where FontKey == SystemFont, VM == DefaultTextStyleModifier<ColorKey, SystemFont> {
  public static func styled(
    as fontTextStyle: Font.TextStyle = .body,
    weight fontWeight: Font.Weight? = .none,
    foregroundColorKey: ColorKey? = .none
  ) -> Self {
    .init { theme in
      DefaultTextStyleModifier(
        theme: theme,
        configuration: .init(
          fontKey: .system,
          fontTextStyle: fontTextStyle,
          fontWeight: fontWeight,
          foregroundColorKey: foregroundColorKey
        )
      )
    }
  }
}

public struct DefaultTextStyleModifier<ColorKey: Hashable, FontKey: Hashable>: ViewModifier {
  public struct Configuration {
    let fontKey: FontKey?
    let fontTextStyle: Font.TextStyle?
    let fontWeight: Font.Weight?
    let foregroundColorKey: ColorKey?
    
    func evaluateFont(using theme: Theme<ColorKey, FontKey>) -> Font? {
      guard let fontKey, let fontTextStyle else {
        return nil
      }
      return theme.font(fontKey, as: fontTextStyle, weight: fontWeight ?? .regular)
    }
  }

  let theme: Theme<ColorKey, FontKey>
  let configuration: Configuration

  init(theme: Theme<ColorKey, FontKey>, configuration: Configuration) {
    self.theme = theme
    self.configuration = configuration
  }

  public func body(content: Content) -> some View {
    let base = baseContent(from: content)
    if #available(iOS 16.0, *) {
      base.fontWeight(configuration.fontWeight)
    } else {
      base
    }
  }
    
  @ViewBuilder
  private func baseContent(from content: Content) -> some View {
    content
      .font(configuration.evaluateFont(using: theme))
      .foregroundColor(configuration.foregroundColorKey.flatMap(theme.color(_:)))
  }
}
