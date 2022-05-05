import SwiftUI

@main
struct ExamplesApp: App {
  var body: some Scene {
    WindowGroup {
      DemoView(theme: .init(registeringFontKeys: [.primary]))
    }
  }
}
