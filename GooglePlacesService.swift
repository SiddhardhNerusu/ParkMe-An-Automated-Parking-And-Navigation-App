import Foundation
import CoreLocation

class GooglePlacesService: ObservableObject {
    @Published var places: [Place] = []

    func fetchNearbyPlaces(latitude: Double, longitude: Double) {
        guard let url = URL(string:
            "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=\(latitude),\(longitude)&radius=2000&type=parking&key=AIzaSyC3AXMZ0Z9qXyYsJ5rYHII8PXlM5jDeSVU")
        else { return }

        URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let data = data else { return }

            do {
                let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]
                let results = json?["results"] as? [[String: Any]] ?? []

                var fetched: [Place] = []

                for entry in results {
                    guard
                        let name = entry["name"] as? String,
                        let geometry = entry["geometry"] as? [String: Any],
                        let loc = geometry["location"] as? [String: Double],
                        let lat = loc["lat"], let lng = loc["lng"]
                    else { continue }

                    let address = entry["vicinity"] as? String ?? "Unknown"
                    let rating = entry["rating"] as? Double ?? 0.0
                    let coord = CLLocationCoordinate2D(latitude: lat, longitude: lng)

                    let place = Place(
                        name: name,
                        address: address,
                        distanceInMiles: nil,
                        rating: rating,
                        coordinate: coord
                    )
                    fetched.append(place)
                }

                DispatchQueue.main.async {
                    self.places = fetched
                }
            } catch {
                print("GooglePlaces decode failed: \(error)")
            }
        }.resume()
    }
}
