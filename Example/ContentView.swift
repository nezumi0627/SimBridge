import SwiftUI

struct ContentView: View {
    @State private var tapCount = 0
    @State private var text = ""

    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                Image(systemName: "iphone.gen3")
                    .font(.system(size: 64))
                    .foregroundStyle(.tint)

                Text("SimBridge Example")
                    .font(.largeTitle.bold())

                Text("Tap, swipe, and type from your Windows browser.")
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.secondary)

                Button("Tap count: \(tapCount)") {
                    tapCount += 1
                }
                .buttonStyle(.borderedProminent)

                TextField("Type something", text: $text)
                    .textFieldStyle(.roundedBorder)

                Text(text.isEmpty ? "Keyboard input appears here" : text)
                    .foregroundStyle(.secondary)
            }
            .padding()
            .navigationTitle("Ready")
        }
    }
}

#Preview {
    ContentView()
}
