import SwiftUI

extension Font.Weight: CaseIterable {
  public static var allCases: [Font.Weight] = [
    .black, .bold, .heavy, .light, .medium, .regular, .semibold, .thin, .ultraLight
  ]
  
  func evaluateFont(baseName: String) -> String {
    let suffix: String = {
      switch self {
      case .black:
        return "-Black"
      case .bold:
        return "-Bold"
      case .heavy:
        return "-Heavy"
      case .light:
        return "-Light"
      case .medium:
        return "-Medium"
      case .regular:
        return "-Regular"
      case .semibold:
        return "-SemiBold"
      case .thin:
        return "-Thin"
      case .ultraLight:
        return "-UltraLight"
      default:
        return "-Regular"
      }
    }()
    return "\(baseName)\(suffix)"
  }
}
