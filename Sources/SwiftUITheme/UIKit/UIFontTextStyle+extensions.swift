#if canImport(UIKit)
import UIKit

extension UIFont.TextStyle: Codable, RawRepresentable {
  // swiftlint:disable cyclomatic_complexity
  public init?(swiftUIFontTextStyleRawValue: String) {
    switch swiftUIFontTextStyleRawValue {
    case "largeTitle":
      self = .largeTitle
    case "title":
      self = .title1
    case "title2":
      self = .title2
    case "title3":
      self = .title3
    case "headline":
      self = .headline
    case "subheadline":
      self = .subheadline
    case "body":
      self = .body
    case "callout":
      self = .callout
    case "footnote":
      self = .footnote
    case "caption":
      self = .caption1
    case "caption2":
      self = .caption2
    default:
      return nil
    }
  }
  public var swiftUIFontTextStyleRawValue: String {
    switch self {
    case .largeTitle:
      return "largeTitle"
    case .title1:
      return "title"
    case .title2:
      return "title2"
    case .title3:
      return "title3"
    case .headline:
      return "headline"
    case .subheadline:
      return "subheadline"
    case .body:
      return "body"
    case .callout:
      return "callout"
    case .footnote:
      return "footnote"
    case .caption1:
      return "caption"
    case .caption2:
      return "caption2"
    default:
      return "unknown"
    }
  }
}
#endif
