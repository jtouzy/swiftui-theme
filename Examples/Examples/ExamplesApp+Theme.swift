import CoreGraphics
import SwiftUITheme

typealias ExamplesAppTheme = Theme<ExamplesAppColor, SystemFont, ExamplesAppConstant>

// MARK: Themed Colors

enum ExamplesAppColor: String, ColorProvider {
  case primary
}

// MARK: Themed constants

enum ExamplesAppConstant: ConstantProvider {
  case spacing(Spacing)
  
  var value: CGFloat {
    switch self {
    case .spacing(let spacing): return spacing.value
    }
  }
}
extension ExamplesAppConstant {
  enum Spacing: CGFloat, ConstantProvider {
    case small = 8.0
    case medium = 16.0
    case large = 32.0
  }
}

// MARK: Themed custom text styles

typealias ExamplesAppTextStyleBuilder = TextStyleBuilder<
  ExamplesAppColor, SystemFont, ExamplesAppConstant,
  DefaultTextStyleModifier<ExamplesAppColor, SystemFont, ExamplesAppConstant>
>

extension ExamplesAppTextStyleBuilder {
  static func headline(color: ExamplesAppColor = .primary) -> Self {
    .styled(as: .headline, foregroundColorKey: color)
  }
}
