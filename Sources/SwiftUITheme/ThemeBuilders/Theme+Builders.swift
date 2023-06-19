extension Theme {
  public static func build<Color, FontKey, Constant>() -> Theme<Color, FontKey, Constant>
  where Color: ColorProvider, FontKey: CaseIterable & FontProvider, Constant: ConstantProvider {
    build(fontKeys: Array(FontKey.allCases))
  }
  public static func build<Color, FontKey, Constant>(fontKeys: [FontKey]) -> Theme<Color, FontKey, Constant>
  where Color: ColorProvider, FontKey: FontProvider, Constant: ConstantProvider {
    .init(fonts: loadAllFontDescriptors(from: fontKeys))
  }
}
