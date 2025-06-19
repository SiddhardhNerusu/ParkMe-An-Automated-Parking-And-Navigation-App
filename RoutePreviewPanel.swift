import SwiftUI
import CoreHaptics
import ConfettiSwiftUI

struct RoutePreviewPanel: View {
    let route: Route
    let onStart: () -> Void
    let selectedPlace: Place?

    @EnvironmentObject var navigationManager: NavigationManager
    @EnvironmentObject var favoritesManager: FavoritesManager
    @AppStorage("isNightMode") var isNightMode: Bool = false

    @State private var showConfetti = false
    @State private var confettiCounter = 0
    @State private var showAlreadyAdded = false
    @State private var engine: CHHapticEngine?

    var body: some View {
        VStack(spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("ETA").font(.caption).foregroundColor(.gray)
                    Text(route.durationText).font(.headline)
                }
                VStack(alignment: .leading, spacing: 4) {
                    Text("Distance").font(.caption).foregroundColor(.gray)
                    let miles = Double(route.distanceInMeters) / 1609.34
                    Text(String(format: "%.1f miles", miles)).font(.headline)
                }
                VStack(alignment: .leading, spacing: 4) {
                    Text("Route").font(.caption).foregroundColor(.gray)
                    Text(route.summary).font(.headline)
                }
                Spacer()
            }

            Button("Start Navigation") {
                onStart()
            }
            .font(.headline)
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)

            if let place = selectedPlace {
                Button(action: {
                    if !favoritesManager.isFavorite(place) {
                        favoritesManager.addToFavorites(place)
                        showConfetti = true
                        confettiCounter += 1
                        playHaptic()
                    } else {
                        withAnimation {
                            showAlreadyAdded = true
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                            showAlreadyAdded = false
                        }
                    }
                }) {
                    Label(
                        favoritesManager.isFavorite(place) ? "Already in Favourites!" : "Add to Favourites",
                        systemImage: favoritesManager.isFavorite(place) ? "star.fill" : "star"
                    )
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(favoritesManager.isFavorite(place) ? Color.gray : Color.purple)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .scaleEffect(showAlreadyAdded ? 1.05 : 1)
                    .animation(.spring(), value: showAlreadyAdded)
                }
                .overlay(
                    Group {
                        if showAlreadyAdded {
                            TyreScreechView()
                                .frame(width: 60, height: 60)
                                .offset(y: -70)
                        }
                    }
                )
            }
        }
        .padding()
        .background(.ultraThinMaterial)
        .cornerRadius(20)
        .padding(.horizontal)
        .shadow(radius: 5)
        .confettiCannon(trigger: $confettiCounter, repetitions: 1, repetitionInterval: 0.1)
        .onAppear { prepareHaptics() }
    }

    private func prepareHaptics() {
        do {
            engine = try CHHapticEngine()
            try engine?.start()
        } catch {
            print("Haptics error: \(error.localizedDescription)")
        }
    }

    private func playHaptic() {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }
        let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: 1.0)
        let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: 1.0)
        let event = CHHapticEvent(eventType: .hapticTransient, parameters: [intensity, sharpness], relativeTime: 0)
        do {
            let pattern = try CHHapticPattern(events: [event], parameters: [])
            let player = try engine?.makePlayer(with: pattern)
            try player?.start(atTime: 0)
        } catch {
            print("Failed to play haptic: \(error.localizedDescription)")
        }
    }
}
