import Foundation
import CoreLocation

class FavoritesManager: ObservableObject {
    @Published var favorites: [Place] = [] {
        didSet { saveFavorites() }
    }

    @Published var customNames: [UUID: String] = [:] {
        didSet { saveNames() }
    }

    init() {
        loadFavorites()
        loadNames()
    }

    func addToFavorites(_ place: Place) {
      
        let alreadyExists = favorites.contains {
            $0.coordinate.latitude == place.coordinate.latitude &&
            $0.coordinate.longitude == place.coordinate.longitude
        }
        guard !alreadyExists else { return }

        favorites.append(place)
    }

    func removeFavorite(_ place: Place) {
        favorites.removeAll {
            $0.coordinate.latitude == place.coordinate.latitude &&
            $0.coordinate.longitude == place.coordinate.longitude
        }
        customNames[place.id] = nil
    }

    func isFavorite(_ place: Place) -> Bool {
        favorites.contains {
            $0.coordinate.latitude == place.coordinate.latitude &&
            $0.coordinate.longitude == place.coordinate.longitude
        }
    }

    func customName(for place: Place) -> String {
        if let match = favorites.first(where: {
            $0.coordinate.latitude == place.coordinate.latitude &&
            $0.coordinate.longitude == place.coordinate.longitude
        }) {
            return customNames[match.id] ?? match.name
        }
        return place.name
    }

    func rename(_ place: Place, to newName: String) {
        if let match = favorites.first(where: {
            $0.coordinate.latitude == place.coordinate.latitude &&
            $0.coordinate.longitude == place.coordinate.longitude
        }) {
            customNames[match.id] = newName
        }
    }

    private func saveFavorites() {
        if let data = try? JSONEncoder().encode(favorites) {
            UserDefaults.standard.set(data, forKey: "favorites")
        }
    }

    private func loadFavorites() {
        if let data = UserDefaults.standard.data(forKey: "favorites"),
           let saved = try? JSONDecoder().decode([Place].self, from: data) {
            favorites = saved
        }
    }

    private func saveNames() {
        let dict = customNames.mapValues { $0 }
        if let data = try? JSONEncoder().encode(dict) {
            UserDefaults.standard.set(data, forKey: "favoriteNames")
        }
    }

    private func loadNames() {
        if let data = UserDefaults.standard.data(forKey: "favoriteNames"),
           let saved = try? JSONDecoder().decode([UUID: String].self, from: data) {
            customNames = saved
        }
    }
}
