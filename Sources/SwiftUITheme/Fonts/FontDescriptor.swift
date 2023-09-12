import SwiftUI

struct FontDescriptor {
  let textStyleDictionary: [Font.TextStyle: TextStyleVariant]
  
  func font(forTextStyle textStyle: Font.TextStyle, weight: Font.Weight) -> Font? {
    textStyleDictionary[textStyle]?.font(forTextStyle: textStyle, weight: weight)
  }
}

extension FontDescriptor {
  enum TextStyleVariant {
    case custom(CustomFont)
    case system
    
    func font(forTextStyle textStyle: Font.TextStyle, weight: Font.Weight) -> Font {
      switch self {
      case .custom(let customFont):
        let dynamicName = customFont.evaluateFontName(for: weight)
        return .custom(dynamicName, size: customFont.size)
      case .system:
        return .system(textStyle)
      }
    }
  }
}
extension FontDescriptor.TextStyleVariant {
  struct CustomFont {
    let bundle: Bundle
    let baseName: String
    let size: CGFloat
    let shouldEvaluateDynamicFontName: Bool
  }
}
extension FontDescriptor.TextStyleVariant.CustomFont {
  func evaluateFontName(for weight: Font.Weight) -> String {
    guard shouldEvaluateDynamicFontName else {
      return baseName
    }
    return weight.evaluateFont(baseName: baseName)
  }
}

extension FontDescriptor {
  static let system: Self = .init(
    textStyleDictionary: Font.TextStyle.allCases.reduce(into: [:], { $0[$1] = .system })
  )
}
