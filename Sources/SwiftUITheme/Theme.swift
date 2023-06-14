import SwiftUI

public final class Theme<ColorKey: Hashable, FontKey: Hashable, SpacingKey: Hashable>: ObservableObject {
  internal var colors: [ColorKey: SwiftUI.Color]
  internal var fonts: [FontKey: FontDescriptor]
  internal var spacings: [SpacingKey: CGFloat]

  internal init(
    colors: [ColorKey: SwiftUI.Color],
    fonts: [FontKey: FontDescriptor],
    spacings: [SpacingKey: CGFloat]
  ) {
    self.colors = colors
    self.fonts = fonts
    self.spacings = spacings
  }
}

extension Theme {
  public func color(_ colorKey: ColorKey) -> SwiftUI.Color {
    colors[colorKey] ?? .clear
  }
  public func colors(_ colorKeys: ColorKey...) -> [SwiftUI.Color] {
    colorKeys.map(color(_:))
  }
  public func font(_ fontKey: FontKey, as textStyle: Font.TextStyle, weight: Font.Weight) -> SwiftUI.Font? {
    fonts[fontKey]?.font(forTextStyle: textStyle, weight: weight)
  }
  public func spacing(_ spacingKey: SpacingKey) -> CGFloat? {
    spacings[spacingKey]
  }
}
