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
        let dynamicName = weight.evaluateFont(baseName: customFont.baseName)
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
  }
}

extension FontDescriptor {
  static let system: Self = .init(
    textStyleDictionary: Font.TextStyle.allCases.reduce(into: [:], { $0[$1] = .system })
  )
}
