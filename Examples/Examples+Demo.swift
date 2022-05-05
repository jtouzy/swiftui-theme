import SwiftUI
import SwiftUITheme

struct DemoView: View {
  @State var theme: Theme

  var body: some View {
    VStack {
      textExamples
    }
  }

  var textExamples: some View {
    VStack {
      // We can use basic static styles already without parameters
      Text("This text is big (BigBold)")
        .textStyle(theme.text(.bigBold))
      // We can use advanced styles, with customization parameters
      // (for example, here to handle dynamic type)
      Text("Hey, i'm customized text! (CustomPrimary)")
        .textStyle(theme.text(.customPrimary(size: .callout)))
    }
  }
}
