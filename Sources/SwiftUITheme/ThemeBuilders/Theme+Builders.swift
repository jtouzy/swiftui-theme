extension Theme {
  public static func build<ColorKey, FontKey, SpacingKey>() -> Theme<ColorKey, FontKey, SpacingKey>
  where ColorKey: CaseIterable & ColorProvider,
        FontKey: CaseIterable & FontProvider,
        SpacingKey: CaseIterable & SpacingProvider {
    build(
      colorKeys: Array(ColorKey.allCases),
      fontKeys: Array(FontKey.allCases),
      spacingKeys: Array(SpacingKey.allCases)
    )
  }
  public static func build<ColorKey, FontKey, SpacingKey>(
    colorKeys: [ColorKey],
    fontKeys: [FontKey],
    spacingKeys: [SpacingKey]
  ) -> Theme<ColorKey, FontKey, SpacingKey>
  where ColorKey: ColorProvider, FontKey: FontProvider, SpacingKey: SpacingProvider {
    .init(
      colors: colorKeys.reduce(into: [:], { $0[$1] = $1.color }),
      fonts: loadAllFontDescriptors(from: fontKeys),
      spacings: spacingKeys.reduce(into: [:], { $0[$1] = $1.spacing })
    )
  }
}
