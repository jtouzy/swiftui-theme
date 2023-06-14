extension Theme {
  public static func build<Color, FontKey, Geometry>() -> Theme<Color, FontKey, Geometry>
  where Color: ColorProvider, FontKey: CaseIterable & FontProvider, Geometry: GeometryProvider {
    build(fontKeys: Array(FontKey.allCases))
  }
  public static func build<Color, FontKey, Geometry>(fontKeys: [FontKey]) -> Theme<Color, FontKey, Geometry>
  where Color: ColorProvider, FontKey: FontProvider, Geometry: GeometryProvider {
    .init(fonts: loadAllFontDescriptors(from: fontKeys))
  }
}
