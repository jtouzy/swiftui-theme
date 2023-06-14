import SwiftUI

extension TextStyleBuilder
where VM == DefaultTextStyleModifier<Color, FontKey, Geometry> {
  public static func styled(
    font fontKey: FontKey? = .none,
    as fontTextStyle: Font.TextStyle = .body,
    weight fontWeight: Font.Weight? = .none,
    foregroundColorKey: Color? = .none,
    backgroundColorKey: Color? = .none,
    textCase: Text.Case? = .none,
    isUnderlined: Bool = false,
    isStrikethrough: Bool = false
  ) -> Self {
    .buildStyle { theme in
      DefaultTextStyleModifier(
        theme: theme,
        configuration: .init(
          fontKey: fontKey,
          fontTextStyle: fontTextStyle,
          fontWeight: fontWeight,
          foregroundColorKey: foregroundColorKey,
          backgroundColorKey: backgroundColorKey,
          textCase: textCase,
          isUnderlined: isUnderlined,
          isStrikethrough: isStrikethrough
        )
      )
    }
  }
}
extension TextStyleBuilder
where FontKey == SystemFont, VM == DefaultTextStyleModifier<Color, SystemFont, Geometry> {
  public static func styled(
    as fontTextStyle: Font.TextStyle = .body,
    weight fontWeight: Font.Weight? = .none,
    foregroundColorKey: Color? = .none,
    backgroundColorKey: Color? = .none,
    textCase: Text.Case? = .none,
    isUnderlined: Bool = false,
    isStrikethrough: Bool = false
  ) -> Self {
    .buildStyle { theme in
      DefaultTextStyleModifier(
        theme: theme,
        configuration: .init(
          fontKey: .system,
          fontTextStyle: fontTextStyle,
          fontWeight: fontWeight,
          foregroundColorKey: foregroundColorKey,
          backgroundColorKey: backgroundColorKey,
          textCase: textCase,
          isUnderlined: isUnderlined,
          isStrikethrough: isStrikethrough
        )
      )
    }
  }
}

public struct DefaultTextStyleModifier<
  Color: ColorProvider, FontKey: Hashable, Geometry: GeometryProvider
>: ViewModifier {
  public struct Configuration {
    let fontKey: FontKey?
    let fontTextStyle: Font.TextStyle?
    let fontWeight: Font.Weight?
    let foregroundColorKey: Color?
    let backgroundColorKey: Color?
    let textCase: Text.Case?
    let isUnderlined: Bool
    let isStrikethrough: Bool
    
    func evaluateFont(using theme: Theme<Color, FontKey, Geometry>) -> Font? {
      guard let fontKey, let fontTextStyle else {
        return nil
      }
      return theme.font(fontKey, as: fontTextStyle, weight: fontWeight ?? .regular)
    }
  }

  let theme: Theme<Color, FontKey, Geometry>
  let configuration: Configuration

  init(theme: Theme<Color, FontKey, Geometry>, configuration: Configuration) {
    self.theme = theme
    self.configuration = configuration
  }

  public func body(content: Content) -> some View {
    let base = baseContent(from: content)
    if #available(iOS 16.0, *) {
      base
        .fontWeight(configuration.fontWeight)
        .underline(configuration.isUnderlined)
        .strikethrough(configuration.isStrikethrough)
    } else {
      base
    }
  }
    
  @ViewBuilder
  private func baseContent(from content: Content) -> some View {
    content
      .font(configuration.evaluateFont(using: theme))
      .foregroundColor(configuration.foregroundColorKey.flatMap(theme.color(_:)))
      .textCase(configuration.textCase)
      .background(configuration.backgroundColorKey.flatMap(theme.color(_:)))
  }
}
