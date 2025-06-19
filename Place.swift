import Foundation
import CoreLocation

struct Place: Identifiable, Codable, Equatable {
    let id: UUID
    let name: String
    let address: String
    var distanceInMiles: Double?
    let rating: Double
    let coordinate: CLLocationCoordinate2D

    enum CodingKeys: String, CodingKey {
        case id, name, address, distanceInMiles, rating, latitude, longitude
    }

    init(id: UUID = UUID(), name: String, address: String, distanceInMiles: Double?, rating: Double, coordinate: CLLocationCoordinate2D) {
        self.id = id
        self.name = name
        self.address = address
        self.distanceInMiles = distanceInMiles
        self.rating = rating
        self.coordinate = coordinate
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        address = try container.decode(String.self, forKey: .address)
        distanceInMiles = try container.decodeIfPresent(Double.self, forKey: .distanceInMiles)
        rating = try container.decode(Double.self, forKey: .rating)
        let lat = try container.decode(Double.self, forKey: .latitude)
        let lng = try container.decode(Double.self, forKey: .longitude)
        coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lng)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(address, forKey: .address)
        try container.encode(distanceInMiles, forKey: .distanceInMiles)
        try container.encode(rating, forKey: .rating)
        try container.encode(coordinate.latitude, forKey: .latitude)
        try container.encode(coordinate.longitude, forKey: .longitude)
    }
}
