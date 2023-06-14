extension Theme {
  public static func build<ColorKey, FontKey, Geometry>() -> Theme<ColorKey, FontKey, Geometry>
  where ColorKey: CaseIterable & ColorProvider, FontKey: CaseIterable & FontProvider, Geometry: GeometryProvider {
    build(colorKeys: Array(ColorKey.allCases), fontKeys: Array(FontKey.allCases))
  }
  public static func build<ColorKey, FontKey, Geometry>(
    colorKeys: [ColorKey], fontKeys: [FontKey]
  ) -> Theme<ColorKey, FontKey, Geometry>
  where ColorKey: ColorProvider, FontKey: FontProvider, Geometry: GeometryProvider {
    .init(
      colors: colorKeys.reduce(into: [:], { $0[$1] = $1.color }),
      fonts: loadAllFontDescriptors(from: fontKeys)
    )
  }
}
