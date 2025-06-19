import SwiftUI

struct SettingsView: View {
    @Environment(\.dismiss) var dismiss
    @AppStorage("isNightMode") var isNightMode: Bool = false
    @AppStorage("useMiles") var useMiles: Bool = true

    @EnvironmentObject var favoritesManager: FavoritesManager
    @EnvironmentObject var directionsService: DirectionsService
    @EnvironmentObject var navigationManager: NavigationManager
    @EnvironmentObject var accountManager: AccountManager

    @State private var selectedPlace: Place? = nil
    @State private var selectedRoute: Route? = nil
    @State private var showRoutePreviewPanel: Bool = false
    @State private var showAccountDetails = false

    var body: some View {
        NavigationView {
            Form {
                Section {
                    AccountHeaderView()
                        .onTapGesture {
                            showAccountDetails = true
                        }
                }
                .listRowBackground(ColorTheme.cardBackground(isNightMode: isNightMode))

                Section {
                    Toggle("Night Mode", isOn: $isNightMode)
                    Toggle("Use Miles (off = KM)", isOn: $useMiles)
                }
                .foregroundColor(ColorTheme.primaryText(isNightMode: isNightMode))
                .listRowBackground(ColorTheme.cardBackground(isNightMode: isNightMode))

                Section {
                    NavigationLink(destination: PaymentHistoryView()) {
                        Label("Payment History", systemImage: "creditcard")
                    }

                    NavigationLink {
                        FavoritesView(
                            selectedPlace: .constant(nil),
                            selectedRoute: .constant(nil),
                            showRoutePreviewPanel: .constant(false)
                        )
                        .environmentObject(favoritesManager)
                        .environmentObject(directionsService)
                        .environmentObject(navigationManager)
                    } label: {
                        Label("Favourites", systemImage: "star.fill")
                    }
                }
                .foregroundColor(ColorTheme.primaryText(isNightMode: isNightMode))
                .listRowBackground(ColorTheme.cardBackground(isNightMode: isNightMode))
            }
            .scrollContentBackground(.hidden)
            .listRowSeparatorTint(Color.gray.opacity(0.3))
            .background(ColorTheme.primaryBackground(isNightMode: isNightMode))
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: { dismiss() }) {
                        Label("Back", systemImage: "chevron.left")
                    }
                    .foregroundColor(ColorTheme.primaryText(isNightMode: isNightMode))
                }
            }
            .sheet(isPresented: $showAccountDetails) {
                AccountDetailView()
                    .environmentObject(accountManager)
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .tint(ColorTheme.toggleTint(isNightMode: isNightMode))
    }
}
