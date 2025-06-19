import SwiftUI
import MapKit
import CoreHaptics

struct FavoritesView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var favoritesManager: FavoritesManager
    @EnvironmentObject var navigationManager: NavigationManager
    @EnvironmentObject var directionsService: DirectionsService
    @AppStorage("isNightMode") var isNightMode: Bool = false

    @Binding var selectedPlace: Place?
    @Binding var selectedRoute: Route?
    @Binding var showRoutePreviewPanel: Bool

    @State private var engine: CHHapticEngine?

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    Text("Favourites")
                        .font(.largeTitle.bold())
                        .foregroundColor(ColorTheme.primaryText(isNightMode: isNightMode))
                        .padding(.horizontal)

                    if favoritesManager.favorites.isEmpty {
                        Text("No favourites added yet.")
                            .foregroundColor(ColorTheme.secondaryText(isNightMode: isNightMode))
                            .frame(maxWidth: .infinity, alignment: .center)
                            .padding()
                    } else {
                        ForEach(favoritesManager.favorites) { place in
                            VStack(alignment: .leading, spacing: 8) {
                                TextField("Name", text: Binding(
                                    get: { favoritesManager.customName(for: place) },
                                    set: { favoritesManager.rename(place, to: $0) }
                                ))
                                .font(.headline)
                                .padding(10)
                                .background(ColorTheme.textFieldBackground(isNightMode: isNightMode)) 
                                .foregroundColor(ColorTheme.primaryText(isNightMode: isNightMode))
                                .cornerRadius(8)

                                Text(place.address)
                                    .font(.subheadline)
                                    .foregroundColor(ColorTheme.secondaryText(isNightMode: isNightMode))

                                if let dist = place.distanceInMiles {
                                    Text(String(format: "%.1f miles away", dist))
                                        .font(.caption)
                                        .foregroundColor(ColorTheme.secondaryText(isNightMode: isNightMode))
                                }

                                HStack {
                                    Button(action: {
                                        favoritesManager.removeFavorite(place)
                                        playHaptic()
                                    }) {
                                        Label("Remove", systemImage: "trash")
                                            .foregroundColor(.red)
                                    }

                                    Spacer()

                                    Button(action: {
                                        playHaptic()
                                        selectedPlace = place

                                        if let userLoc = CLLocationManager().location?.coordinate {
                                            directionsService.fetchRoute(from: userLoc, to: place.coordinate) { route in
                                                if let route = route {
                                                    DispatchQueue.main.async {
                                                        selectedRoute = route
                                                        showRoutePreviewPanel = true
                                                        dismiss()
                                                    }
                                                }
                                            }
                                        }
                                    }) {
                                        Label("Navigate", systemImage: "car")
                                            .foregroundColor(.blue)
                                    }
                                }
                                .font(.caption)
                            }
                            .padding()
                            .background(ColorTheme.cardBackground(isNightMode: isNightMode))
                            .cornerRadius(14)
                            .shadow(
                                color: isNightMode ? .black.opacity(0.2) : .gray.opacity(0.2),
                                radius: 5, x: 0, y: 2
                            )
                            .padding(.horizontal)
                        }
                    }
                }
                .padding(.top, 12)
            }
            .background(ColorTheme.primaryBackground(isNightMode: isNightMode))
            .navigationTitle("")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: { dismiss() }) {
                        Label("Back", systemImage: "chevron.left")
                    }
                    .foregroundColor(ColorTheme.primaryText(isNightMode: isNightMode))
                }
            }
        }
        .tint(.blue)
        .onAppear {
            prepareHaptics()
        }
    }

    private func prepareHaptics() {
        do {
            engine = try CHHapticEngine()
            try engine?.start()
        } catch {
            print("Haptics engine failed: \(error.localizedDescription)")
        }
    }

    private func playHaptic() {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }

        let event = CHHapticEvent(
            eventType: .hapticTransient,
            parameters: [
                .init(parameterID: .hapticIntensity, value: 1),
                .init(parameterID: .hapticSharpness, value: 1)
            ],
            relativeTime: 0
        )

        do {
            let pattern = try CHHapticPattern(events: [event], parameters: [])
            let player = try engine?.makePlayer(with: pattern)
            try player?.start(atTime: 0)
        } catch {
            print("Haptic error: \(error)")
        }
    }
}
