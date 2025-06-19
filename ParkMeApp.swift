import SwiftUI

@main
struct ParkMeApp: App {
    @StateObject private var accountManager = AccountManager()
    @State private var showSplash = true
    @State private var isLoggedIn = false
    @AppStorage("shouldShowSplashAgain") var shouldShowSplashAgain: Bool = false

    var body: some Scene {
        WindowGroup {
            ZStack {
                if showSplash {
                    SplashScreenView()
                } else if !isLoggedIn {
                    LoginView(isLoggedIn: $isLoggedIn)
                        .environmentObject(accountManager)
                } else {
                    ContentView()
                        .environmentObject(accountManager)
                }
            }
            .onAppear {
                DispatchQueue.main.async {
                    if shouldShowSplashAgain {
                        showSplash = true
                        shouldShowSplashAgain = false
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                        withAnimation {
                            showSplash = false
                        }
                    }
                }
            }
        }
    }
}
