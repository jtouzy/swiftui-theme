import SwiftUI

public struct FontManager: Equatable {
  private var bundle: Bundle
  private var styleDictionary: StyleDictionary

  public init(
    registeringFontKeys fontKeys: [Theme.FontKey],
    from bundle: Bundle
  ) {
    self.bundle = bundle
    self.styleDictionary = loadAllFontStyles(from: fontKeys, in: bundle)
  }
}

extension FontManager {
  fileprivate typealias FontStyleDictionary = [Font.TextStyle.RawValue: FontDescription]
  fileprivate typealias StyleDictionary = [Theme.FontKey: FontStyleDictionary]

  fileprivate struct FontDescription: Codable, Equatable {
    let fontName: String
    let fontSize: CGFloat
  }
}

extension FontManager {
  public func font(
    key: Theme.FontKey,
    style: Font.TextStyle,
    weight: Font.Weight?
  ) -> Font {
    guard let fontStyleDescription = styleDictionary[key]?[style.rawValue] else {
      return Font.system(style)
    }
    return .custom(
      calculateFontName(for: key, defaultName: fontStyleDescription.fontName, weight: weight),
      size: fontStyleDescription.fontSize,
      relativeTo: style
    )
  }
}

#if canImport(UIKit)
extension FontManager {
  public func uiFont(
    key: Theme.FontKey,
    style: UIFont.TextStyle,
    weight: UIFont.Weight?,
    handlesAccessibility: Bool = true
  ) -> UIFont {
    guard
      let fontStyleDescription = styleDictionary[key]?[style.swiftUIFontTextStyleRawValue],
      let font = UIFont(name: fontStyleDescription.fontName, size: fontStyleDescription.fontSize)
    else {
      return UIFont.preferredFont(forTextStyle: style)
    }
    guard handlesAccessibility else {
      return font
    }
    let fontMetrics = UIFontMetrics(forTextStyle: style)
    return fontMetrics.scaledFont(for: font)
  }
}
#endif

private func loadAllFontStyles(from fontKeys: [Theme.FontKey], in bundle: Bundle) -> FontManager.StyleDictionary {
  let propertyListDecoder = PropertyListDecoder()
  return fontKeys.reduce(into: [:]) { fontKeysDictionary, fontKey in
    guard
      let url = bundle.url(forResource: fontKey.id, withExtension: "plist"),
      let data = try? Data(contentsOf: url),
      let fontStyleDictionary = try? propertyListDecoder.decode(
        FontManager.FontStyleDictionary.self,
        from: data
      )
    else {
      return
    }
    fontKeysDictionary[fontKey] = fontStyleDictionary
  }
}

private func calculateFontName(
  for fontKey: Theme.FontKey,
  defaultName: String,
  weight: Font.Weight?
) -> String {
  if let weight = weight {
    return calculateFontName(basedOn: fontKey, withWeight: weight)
  }
  return defaultName
}

private func calculateFontName(
  basedOn fontKey: Theme.FontKey,
  withWeight fontWeight: Font.Weight
) -> String {
  let baseFontName = fontKey.id
  switch fontWeight {
  case .black:
    return "\(baseFontName)-Black"
  case .bold:
    return "\(baseFontName)-Bold"
  case .heavy:
    return "\(baseFontName)-Heavy"
  case .light:
    return "\(baseFontName)-Light"
  case .medium:
    return "\(baseFontName)-Medium"
  case .regular:
    return baseFontName
  case .semibold:
    return "\(baseFontName)-SemiBold"
  case .thin:
    return "\(baseFontName)-Thin"
  case .ultraLight:
    return "\(baseFontName)-UltraLight"
  default:
    return baseFontName
  }
}
