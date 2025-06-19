import Foundation
import CoreLocation

struct Route: Identifiable, Equatable {
    let id = UUID()
        let overviewPolyline: [CLLocationCoordinate2D]
        let summary: String
        let durationText: String
        let durationValue: Int
        let steps: [String]
        let distanceText: String         
        let distanceValue: Int
   

    var distanceInMeters: Double {   
        return Double(distanceValue)
    }

    static func == (lhs: Route, rhs: Route) -> Bool {
        return lhs.id == rhs.id
    }
}
