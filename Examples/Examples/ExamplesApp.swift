import SwiftUI

@main
struct ExamplesApp: App {
  @ObservedObject var theme: ExamplesAppTheme = .build()
  
  var body: some Scene {
    WindowGroup {
      ContentView().environmentObject(theme)
    }
  }
}

struct ContentView: View {
  @EnvironmentObject var theme: ExamplesAppTheme
  
  var body: some View {
    VStack {
      Text("My primary styled text!").textStyle(.headline())
    }
    .padding(theme.constant(.spacing(.medium)))
  }
}
