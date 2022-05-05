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
      Text("This text is big")
        .textStyle(theme.text(.bigBold)) // or whatever you want to define
      Button("Tap me")
        .buttonStyle(theme.button(.primary)) // or whatever you want to define
      MyCustomComponent()
        .myCustomComponentStyle(theme.myCustomComponent(.primary)) // or whatever, you got it
    }
  }
}
```

* [Motivations](README.md#Motivations)
* [Make your own Design System - The steps](README.md#Make-Your-Own-Design-System-The-Steps)
* [A note on custom Fonts](README.md#A-Note-On-Custom-Fonts)

## Motivations

Mainly, because :
* Who does not want to share & reuse styles accross multiple views for SwiftUI components ?
* Who does not want to have a unified API, Vanilla SwiftUI-like, to handle styles the same way on any component ?

## Make your own Design System - The steps

For some examples, you can check the [Examples](Examples) folder.

### Define your colors

SwiftUITheme handle colors using named colors from `.xcassets` files. You need to define **Color Keys** for accessing your colors. Color keys are entirely free to define, you can define every name you want, and you will get build-time checkings for color names.

```swift
import SwiftUITheme

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
import SwiftUITheme

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
import SwiftUITheme

struct Demo: View {
  @State var theme: Theme

  var body: some View {
    Text("This text is big")
      .textStyle(theme.text(.bigBold))
  }
}
```

## A note on custom Fonts

TODO.
