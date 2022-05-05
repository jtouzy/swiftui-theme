import SwiftUI

// ========================================================================
// MARK: TextStyleBuilder
// This layer is used to get the availability to define static properties to list all your styles.
// It's only a factory function for building your style class from the given theme.
// ========================================================================

public struct TextStyleBuilder<VM: ViewModifier> {
  public typealias BuildStyle = (Theme) -> VM

  public let buildStyle: BuildStyle

  public init(buildStyle: @escaping BuildStyle) {
    self.buildStyle = buildStyle
  }
}

// ========================================================================
// MARK: Theme API
// This API must be exposed to allow ViewModifier creation based on a theme in SwiftUI views.
// ========================================================================

extension Theme {
  /// Theme-styled Text API.
  /// - Parameter builder: Builder used to construct the related text ViewModifier.
  /// - Returns: A ViewModifier created based on the builder definition.
  public func text<VM>(_ builder: TextStyleBuilder<VM>) -> VM where VM: ViewModifier {
    builder.buildStyle(self)
  }
}

// ========================================================================
// MARK: SwiftUI
// This API is used to be consistent with SwiftUI APIs like ButtonStyle
// ========================================================================

extension View {
  public func textStyle<VM>(_ viewModifier: VM) -> some View where VM: ViewModifier {
    modifier(viewModifier)
  }
}

// ========================================================================
// MARK: Default text modifier for ready-to-use SDK
// ========================================================================

public struct DefaultTextViewModifier: ViewModifier {
  let theme: Theme
  let font: Theme.FontKey
  let textStyle: Font.TextStyle
  let foregroundColor: Theme.ColorKey?

  public init(
    theme: Theme,
    font: Theme.FontKey = .default,
    textStyle: Font.TextStyle = .body,
    foregroundColor: Theme.ColorKey? = .none
  ) {
    self.theme = theme
    self.font = font
    self.textStyle = textStyle
    self.foregroundColor = foregroundColor
  }

  public func body(content: Content) -> some View {
    content
      .font(theme.font(font, style: textStyle))
      .foregroundColor(foregroundColor.map { theme.color($0) } ?? .none)
  }
}
