import SwiftUI

struct SplashScreenView: View {
    @State private var showMainView = false
    @AppStorage("isNightMode") private var isNightMode: Bool = false

    var body: some View {
        ZStack {
            (isNightMode ? Color.black : Color.white)
                .ignoresSafeArea()

            Image("parkme_logo")
                .resizable()
                .scaledToFit()
                .frame(width: 200, height: 200)
                .opacity(showMainView ? 0 : 1)
                .scaleEffect(showMainView ? 1.1 : 1.0)
                .animation(.easeOut(duration: 1.2), value: showMainView)
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                withAnimation {
                    showMainView = true
                }
            }
        }
        .fullScreenCover(isPresented: $showMainView) {
            ContentView()
        }
    }
}
