import SwiftUI

public final class Theme<Color: ColorProvider, FontKey: Hashable, Constant: ConstantProvider>: ObservableObject {
  internal var fonts: [FontKey: FontDescriptor]

  internal init(fonts: [FontKey: FontDescriptor]) {
    self.fonts = fonts
  }
}

extension Theme {
  public func color(_ color: Color) -> SwiftUI.Color {
    color.color
  }
  public func colors(_ colors: Color...) -> [SwiftUI.Color] {
    colors.map(color(_:))
  }
  public func font(_ fontKey: FontKey, as textStyle: Font.TextStyle, weight: Font.Weight) -> SwiftUI.Font? {
    fonts[fontKey]?.font(forTextStyle: textStyle, weight: weight)
  }
  public func constant(_ constant: Constant) -> CGFloat {
    constant.value
  }
}
