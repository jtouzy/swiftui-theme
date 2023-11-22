# SwiftUI Theme

<img src="https://img.shields.io/badge/version-1.1.0-blue"/>

🎨 Easy, unified & extensible theming framework for SwiftUI apps.

A quick demo is worth 1.000 words:

```swift
import SwiftUITheme

struct Demo: View {
  // The theme will drive all your UI styles
  @EnvironmentObject var theme: MyTheme

  var body: some View {
    VStack {
      Button("Tap me")
        .buttonStyle(.primary) // or whatever you want to define
      Text("This text is big")
        .textStyle(.bigBold) // or whatever you want to define
      MyCustomComponent()
        .myCustomComponentStyle(.primary) // or whatever, you got it
    }
    .background(theme.color(.accent))
  }
}
```

* [Motivations](README.md#Motivations)
* [Make your own Design System](README.md#Make-Your-Own-Design-System)
* [A note on custom Fonts](README.md#A-Note-On-Custom-Fonts)

## Motivations

Developers do not like wasting time on repetitive, time-consuming tasks: for instance, implementing the same UI components again and again. This can be solved with a proper component library, which will maintain consistency across the product and enhance code reusability and a result, development efficiency.

SwiftUI allows us to do it with basic components: APIs like `buttonStyle` allow us to define custom implementations of the `ButtonStyle` protocol. And since iOS15, Apple introduced static accessors to define custom styles, such as `buttonStyle(.rounded)`.

This library is widely inspired by those concepts, but allows developers to define styles on every component (even those which miss some native API for styling), in a grouped way, using a `Theme`. Colors, Fonts, Modifiers, everything is in a single place: your own design system definition.

Let's talk about that.

## Make your own Design System

For some more detailed examples, you can check the [Examples](Examples) folder.

### Defining your theme

#### Step 1: Define your colors

Yours colors have to be defined on your side. You must implement the `ColorProvider` protocol, to indicate to the library the color you want to use for each key. And, eventually, the bundle in which you want to get the resources from. With those keys, you will get a build-time check for accessing your colors.

```swift
public enum MyThemeColor: ColorProvider {
  case background
  case primary
  case secondary

  public var bundle: Bundle { .module }
  public var color: Color {
    return switch self {
      case .background: /* Color from your preferred source, most likely xcassets color definition */
      case .primary: /* Color from your preferred source, most likely xcassets color definition */
      case .secondary: /* Color from your preferred source, most likely xcassets color definition */
    }
  }
}
```

For better naming, we recommend you to use predefined color systems, like [Material Color System](https://material.io/design/color/the-color-system.html).

To increase development speed and reduce common errors, you can use tools like [SwiftGen](https://github.com/SwiftGen/SwiftGen) to automatically generate your color keys from your asset catalogs.

#### Step 2: Define your fonts

For automatic management, you should provide which fonts will be used in your app. If you want to use the default font, simply use `SystemFont` and you will have nothing more to do.

If you want to use custom fonts, just check below.

#### Last step: Define your constants

In a whole design system definition, most of the time you will have lots of paddings, spacings everywhere in your views. When you want to change them, it can be a mess to search everywhere and update everything. The theme also provides a way for you to access to some constants to define at your app level.

```swift
public enum MyThemeConstants: CGFloat, ConstantProvider {
  case small = 4.0
  case medium = 8.0
  case large = 16.0
}
```

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

The implementation of all those tools is widely inspired by [this UseYourLoaf article](https://useyourloaf.com/blog/scaling-custom-swiftui-fonts-with-dynamic-type/
).

### Don't need to register custom fonts in Info.plist

`SwiftUITheme` will automatically load your custom fonts if you give custom font keys to your `Theme`.

```swift
extension Theme.FontKey {
  static let primary: Self = "Roboto"
}
// With this initializer, SwiftUITheme will dynamically load Fonts in your app. You don't need to list them in your plist file.
// NOTE: If your fonts come from another bundle, you can specify this custom bundle to the initializer.
let theme: Theme = .init(registeringFontKeys: [.primary])
```

### Make your custom font / dynamic type association

The library will search for a `Roboto.plist` (if you font key is called `Roboto`) file to get the Dynamic Type mapping. If it is provided correctly, dynamic type will be automatically applied when you use this font.

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

## Feedbacks

Feedbacks & community participation is appreciated.

Feel free to open an issue or a pull request to improve SwiftUITheme.
