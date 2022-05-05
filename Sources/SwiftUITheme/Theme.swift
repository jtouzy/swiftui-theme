import Foundation

public struct Theme: Equatable {
  let resourceBundle: Bundle
  let fontManager: FontManager

  public init(
    registeringFontKeys: [FontKey] = [],
    resourcesFromBundle resourceBundle: Bundle = .main
  ) {
    self.resourceBundle = resourceBundle
    self.fontManager = .init(registeringFontKeys: registeringFontKeys, from: resourceBundle)
    loadBundleFontsIfNeeded()
  }
}
