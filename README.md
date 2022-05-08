# SwiftUI Theme

<img src="https://img.shields.io/badge/version-0.1.0-blue"/>

🎨 Easy, unified & extensible theming framework for SwiftUI apps.

Nothing speaks better than a quick demo :

```swift
import SwiftUITheme

struct Demo: View {
  // The theme will drive all your UI styles
  @State var theme: Theme

  var body: some View {
    VStack {
      Button("Tap me")
        .buttonStyle(theme.button(.primary)) // or whatever you want to define
      Text("This text is big")
        .textStyle(theme.text(.bigBold)) // or whatever you want to define
      MyCustomComponent()
        .myCustomComponentStyle(theme.myCustomComponent(.primary)) // or whatever, you got it
    }
    .background(theme.color(.accent))
  }
}
```

* [Motivations](README.md#Motivations)
* [Make your own Design System](README.md#Make-Your-Own-Design-System)
* [A note on custom Fonts](README.md#A-Note-On-Custom-Fonts)

## Motivations

Every app developer wants to not lose time designing an app. Once a component design is defined, it's a time-gainer to reuse it everywhere in the app. SwiftUI allows us to do it with basic components : APIs like `buttonStyle` allows us to define custom implementations of `ButtonStyle` protocol. And since iOS15, Apple introduced static accessors to define custom styles, such as `buttonStyle(.rounded)`.

This library is widely inspired by those concepts, but allows developers to define styles on every components (even those which miss some native API for styling), in a grouped way, using a `Theme`. Colors, Fonts, Modifiers, everything is in a single place : Your own design system definition.

Let's talk about that.

## Make your own Design System

For some more detailed examples, you can check the [Examples](Examples) folder.

### Define your colors

SwiftUITheme handle colors using named colors from `.xcassets` files. You need to define **Color Keys** for accessing your colors. Color keys are entirely free to define, you can define every name you want, and you will get build-time checkings for color names.

```swift
extension Theme.ColorKey {
  // Define a primary color usable in SwiftUI views.
  // The string key must match to the named color in your Assets catalog.
  static let primary: Self = "PrimaryColor"
}
```

For better naming, we recommend you to use pre-defined color systems, like [Material Color System](https://material.io/design/color/the-color-system.html).

To increase development speed and reduce common errors, you can use tools like [SwiftGen](https://github.com/SwiftGen/SwiftGen) to automatically generate your color keys from your asset catalogs.

### Define your styles

Now that you have your colors and fonts defined, you can define your component's styles. The way of defining styles depends on how SwiftUI's native components manage their styles. For most components, you just have to define `Style` protocols implementation. But in some case like `Text`s, ViewModifiers are the best way to customize your component style.

```swift
extension TextStyleBuilder where VM == MyBigBoldPrimaryTextModifier {
  // Define the key to use in your SwiftUI views for your textStyles
  static let bigBold: Self = .init(buildStyle: MyBigBoldPrimaryTextModifier.init(theme:))
}
// Define the ViewModifier to use to describe your style behavior
struct MyBigBoldPrimaryTextModifier: ViewModifier {
  let theme: Theme

  func body(content: Content) -> some View {
    content
      .font(theme.font(.primary, style: .title, weight: .bold))
      .foregroundColor(theme.color(.primary))
  }
}
```

### Finally, use your styles

Everything is ready now. You can use your styles in your SwiftUI views.

```swift
struct Demo: View {
  @State var theme: Theme

  var body: some View {
    Text("This text is big")
      .textStyle(theme.text(.bigBold))
  }
}
```

## A note on custom Fonts

Custom fonts can be used with `swift-theme`. In parallel, we encourage the use of Dynamic Type for better Accessibility. From scratch, it can be complex to use custom fonts with dynamic type in SwiftUI. `swiftui-theme` embed some tools to help you define Dynamic Type using your custom fonts.

The implementation of all those tools is widely inspired by [this UseYourLoad article](https://useyourloaf.com/blog/scaling-custom-swiftui-fonts-with-dynamic-type/
).

### Don't need to register custom fonts in Info.plist

`SwiftUITheme` will automatically load your custom fonts if you give to your `Theme` custom font keys.

```swift
extension Theme.FontKey {
  static let primary: Self = "Roboto"
}
// With this initializer, SwiftUITheme will dynamically load Fonts in your app. You don't need to list them in your plist file.
// NOTE: If your fonts come from another bundle, you can specify this custom bundle to the initializer.
let theme: Theme = .init(registeringFontKeys: [.primary])
```

### Make your custom font / dynamic type association

The library will search for a `Roboto.plist` (if you font key is called `Roboto`) file to get the Dynamic Type mapping. If it's provided correctly, dynamic type will be automatically applied when you use this font.

```xml
<!-- Example of large title definition -->
<key>largeTitle</key>
<dict>
  <key>fontName</key>
  <string>Roboto-Black</string>
  <key>fontSize</key>
  <integer>30</integer>
</dict>
```

You can find a [full example](Examples/Fonts/Roboto/Roboto.plist) of custom font mapping in the Examples app.
