import Foundation
import CoreLocation
import Combine

class NavigationManager: ObservableObject {
    @Published var isNavigating: Bool = false
    @Published var simulatedPosition: CLLocationCoordinate2D?
    @Published var navigationProgress: Double = 0.0
    @Published var currentInstruction: String = ""
    var onArrival: (() -> Void)?

    private var routePolyline: [CLLocationCoordinate2D] = []
    private var currentIndex = 0
    private var timer: Timer?

    private var travelStartTime: Date?
    var travelDuration: TimeInterval {
        guard let start = travelStartTime else { return 0 }
        return Date().timeIntervalSince(start)
    }
    var totalDistance: Double = 0.0

    func startNavigationSimulation(to polyline: [CLLocationCoordinate2D]) {
        guard polyline.count >= 2 else { return }

        self.routePolyline = polyline
        self.currentIndex = 0
        self.isNavigating = true
        self.simulatedPosition = polyline.first
        self.navigationProgress = 0.0
        self.travelStartTime = Date()
        self.totalDistance = 0.0

        let totalSteps = 30
        var step = 0

        let start = polyline.first!
        let end = polyline.last!

        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 5.0 / Double(totalSteps), repeats: true) { [weak self] t in
            guard let self = self else { return }
            step += 1
            let progress = Double(step) / Double(totalSteps)

            let lat = start.latitude + (end.latitude - start.latitude) * progress
            let lon = start.longitude + (end.longitude - start.longitude) * progress
            let newPosition = CLLocationCoordinate2D(latitude: lat, longitude: lon)

            if let last = self.simulatedPosition {
                let d = CLLocation(latitude: lat, longitude: lon).distance(from: CLLocation(latitude: last.latitude, longitude: last.longitude))
                self.totalDistance += d / 1609.34
            }

            self.simulatedPosition = newPosition
            self.navigationProgress = progress
            self.updateInstruction()

            if step >= totalSteps {
                t.invalidate()
                self.stopNavigation()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.onArrival?()
                }
            }
        }
    }

    private func updateInstruction() {
        guard currentIndex + 1 < routePolyline.count else { return }
        guard let current = simulatedPosition else { return }

        let next = routePolyline[min(currentIndex + 1, routePolyline.count - 1)]
        let deltaX = next.longitude - current.longitude
        let deltaY = next.latitude - current.latitude

        if abs(deltaX) > abs(deltaY) {
            currentInstruction = deltaX > 0 ? "Turn right" : "Turn left"
        } else {
            currentInstruction = "Go straight"
        }
    }

    func stopNavigation() {
        timer?.invalidate()
        timer = nil
        isNavigating = false
        simulatedPosition = nil
        navigationProgress = 1.0
        currentInstruction = "You have arrived"
    }
}
