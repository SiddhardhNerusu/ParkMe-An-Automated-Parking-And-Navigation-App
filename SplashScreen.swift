import SwiftUI

struct SplashScreen: View {
    @State private var isActive = false

    var body: some View {
        Group {
            if isActive {
                ContentView()
            } else {
                VStack {
                    Image("parkme_logo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 200)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.white)
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                withAnimation { isActive = true }
            }
        }
    }
}
