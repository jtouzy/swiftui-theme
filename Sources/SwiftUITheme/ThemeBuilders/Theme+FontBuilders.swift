import SwiftUI

public protocol FontProvider {
  var bundle: Bundle { get }
  var fontDescriptorFileName: String { get }
  var shouldEvaluateDynamicFontName: Bool { get }
}

public extension FontProvider {
  var bundle: Bundle { .main }
  var shouldEvaluateDynamicFontName: Bool { true }
}

public extension FontProvider where Self: RawRepresentable, RawValue == String {
  var fontDescriptorFileName: String { rawValue }
}

public enum SystemFont: String, CaseIterable, FontProvider {
  case system
}

// MARK: Custom fonts informations loading

internal enum FontDescriptorPropertyList {
  fileprivate typealias ByTextStyleDictionary = [Font.TextStyle.RawValue: FontProperties]
  fileprivate struct FontProperties: Decodable {
    let fontName: String
    let fontSize: CGFloat
  }
}

internal func loadAllFontDescriptors<FontKey>(from providers: [FontKey]) -> [FontKey: FontDescriptor]
where FontKey: FontProvider {
  let propertyListDecoder = PropertyListDecoder()
  let fontDescriptors: [FontKey: FontDescriptor] = providers.reduce(into: [:]) { finalDictionary, fontProvider in
    guard fontProvider is SystemFont == false else {
      finalDictionary[fontProvider] = .system
      return
    }
    guard
      let fontDescriptorFileURL = fontProvider.bundle.url(
        forResource: fontProvider.fontDescriptorFileName,
        withExtension: "plist"
      )
    else {
      assertionFailure("Could not load PLIST file for \(fontProvider.fontDescriptorFileName) custom font")
      return
    }
    do {
      let fontDescriptorFileData = try Data(contentsOf: fontDescriptorFileURL)
      let propertyListFontPropertiesDictionary = try propertyListDecoder.decode(
        FontDescriptorPropertyList.ByTextStyleDictionary.self,
        from: fontDescriptorFileData
      )
      let transformPListToTextStyleMapping: (
        inout [Font.TextStyle: FontDescriptor.TextStyleVariant],
        FontDescriptorPropertyList.ByTextStyleDictionary.Element
      ) -> Void = { dictionary, propertyListDictionaryElement in
        guard let fontTextStyle = Font.TextStyle(rawValue: propertyListDictionaryElement.key) else {
          return
        }
        dictionary[fontTextStyle] = .custom(
          .init(
            bundle: fontProvider.bundle,
            baseName: propertyListDictionaryElement.value.fontName,
            size: propertyListDictionaryElement.value.fontSize,
            shouldEvaluateDynamicFontName: fontProvider.shouldEvaluateDynamicFontName
          )
        )
      }
      finalDictionary[fontProvider] = .init(
        textStyleDictionary: propertyListFontPropertiesDictionary.reduce(into: [:], transformPListToTextStyleMapping)
      )
    } catch {
      assertionFailure("Could not load informations from \(fontProvider.fontDescriptorFileName).plist file: \(error)")
      return
    }
  }
  loadDynamically(Array(fontDescriptors.values))
  return fontDescriptors
}

private func loadDynamically(_ fontDescriptors: [FontDescriptor]) {
  fontDescriptors
    .map(\.textStyleDictionary)
    .flatMap(\.values)
    .compactMap { variant -> FontDescriptor.TextStyleVariant.CustomFont? in
      guard case .custom(let customFont) = variant else { return nil }
      return customFont
    }
    .uniqued(by: \.baseName)
    .flatMap { variant in
      Font.Weight.allCases.compactMap { weight in
        variant.bundle.url(forResource: weight.evaluateFont(baseName: variant.baseName), withExtension: "ttf")
      }
    }
    .forEach { UIFont.register(from: $0) }
}

private extension Array {
  func uniqued<Value>(by keyPath: KeyPath<Element, Value>) -> [Element] where Value: Hashable {
    var seen = Set<Value>()
    return filter { seen.insert($0[keyPath: keyPath]).inserted }
  }
}

private extension UIFont {
  static func register(from url: URL) {
    guard
      let fontDataProvider = CGDataProvider(url: url as CFURL),
      let font = CGFont(fontDataProvider)
    else {
      return
    }
    var error: Unmanaged<CFError>?
    CTFontManagerRegisterGraphicsFont(font, &error)
  }
}
