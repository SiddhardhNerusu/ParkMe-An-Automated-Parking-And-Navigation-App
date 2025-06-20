import Foundation
import CoreLocation

class DirectionsService: ObservableObject {
    @Published var routes: [Route] = []

    private let apiKey = "x"

    func fetchRoute(from origin: CLLocationCoordinate2D, to destination: CLLocationCoordinate2D, completion: @escaping (Route?) -> Void) {
        routes = []

        let originStr = "\(origin.latitude),\(origin.longitude)"
        let destinationStr = "\(destination.latitude),\(destination.longitude)"
        let urlStr = """
        https://maps.googleapis.com/maps/api/directions/json?origin=\(originStr)&destination=\(destinationStr)&alternatives=true&key=\(apiKey)
        """

        guard let url = URL(string: urlStr) else {
            completion(nil)
            return
        }

        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                completion(nil)
                return
            }

            do {
                let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                let routesData = json?["routes"] as? [[String: Any]] ?? []

                var parsed: [Route] = []

                for route in routesData {
                    guard
                        let overview = route["overview_polyline"] as? [String: Any],
                        let points = overview["points"] as? String,
                        let legs = route["legs"] as? [[String: Any]],
                        let leg = legs.first,
                        let duration = leg["duration"] as? [String: Any],
                        let durationText = duration["text"] as? String,
                        let durationValue = duration["value"] as? Int,
                        let distance = leg["distance"] as? [String: Any],
                        let distanceText = distance["text"] as? String,
                        let distanceValue = distance["value"] as? Int,
                        let summary = route["summary"] as? String
                    else { continue }

                    let coords = self.decodePolyline(points)

                    let routeObj = Route(
                        overviewPolyline: coords,
                        summary: summary,
                        durationText: durationText,
                        durationValue: durationValue,
                        steps: [],
                        distanceText: distanceText,
                        distanceValue: distanceValue
                    )

                    parsed.append(routeObj)
                }

                DispatchQueue.main.async {
                    self.routes = parsed
                    completion(parsed.first)
                }

            } catch {
                print("Decode failed: \(error)")
                DispatchQueue.main.async {
                    completion(nil)
                }
            }

        }.resume()
    }

    func decodePolyline(_ encoded: String) -> [CLLocationCoordinate2D] {
        var coords: [CLLocationCoordinate2D] = []
        var index = encoded.startIndex
        var lat = 0, lng = 0

        while index < encoded.endIndex {
            var b: Int = 0, shift = 0, result = 0
            repeat {
                b = Int(encoded[index].asciiValue! - 63)
                result |= (b & 0x1F) << shift
                shift += 5
                index = encoded.index(after: index)
            } while b >= 0x20
            let dlat = (result & 1) != 0 ? ~(result >> 1) : result >> 1
            lat += dlat

            shift = 0
            result = 0
            repeat {
                b = Int(encoded[index].asciiValue! - 63)
                result |= (b & 0x1F) << shift
                shift += 5
                index = encoded.index(after: index)
            } while b >= 0x20
            let dlng = (result & 1) != 0 ? ~(result >> 1) : result >> 1
            lng += dlng

            let finalLat = Double(lat) / 1e5
            let finalLng = Double(lng) / 1e5
            coords.append(CLLocationCoordinate2D(latitude: finalLat, longitude: finalLng))
        }
        return coords
    }
}
