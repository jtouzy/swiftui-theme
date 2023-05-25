import SwiftUI

// ========================================================================
// MARK: ContainerStyleBuilder
// This layer is used to get the availability to define static properties to list all your styles.
// It's only a factory function for building your style class from the given theme.
// ========================================================================

public struct ContainerStyleBuilder<ColorKey: Hashable, FontKey: Hashable, VM: ViewModifier> {
  public typealias BuildStyle = (Theme<ColorKey, FontKey>) -> VM

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
  public func container<VM: ViewModifier>(_ builder: ContainerStyleBuilder<ColorKey, FontKey, VM>) -> VM {
    builder.buildStyle(self)
  }
}

// ========================================================================
// MARK: SwiftUI
// This API is used to be consistent with SwiftUI APIs like ButtonStyle
// ========================================================================

extension View {
  public func containerStyle<VM>(_ viewModifier: VM) -> some View where VM: ViewModifier {
    modifier(viewModifier)
  }
}
