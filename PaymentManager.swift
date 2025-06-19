import Foundation

struct Payment: Identifiable, Codable {
    let id = UUID()
    let locationName: String
    let startTime: Date
    let endTime: Date
    let duration: Int
    let totalCost: Double
}

class PaymentManager: ObservableObject {
    static let shared = PaymentManager()

    @Published var payments: [Payment] = []

    private let storageKey = "savedPayments"

    private init() {
        load()
    }

    func addPayment(locationName: String, startTime: Date, endTime: Date, duration: Int, totalCost: Double) {
        let newPayment = Payment(
            locationName: locationName,
            startTime: startTime,
            endTime: endTime,
            duration: duration,
            totalCost: totalCost
        )
        payments.append(newPayment)
        save()
    }

    private func save() {
        do {
            let data = try JSONEncoder().encode(payments)
            UserDefaults.standard.set(data, forKey: storageKey)
        } catch {
            print("Error saving payments: \(error)")
        }
    }

    private func load() {
        if let data = UserDefaults.standard.data(forKey: storageKey) {
            do {
                payments = try JSONDecoder().decode([Payment].self, from: data)
            } catch {
                print("Error loading payments: \(error)")
                payments = []
            }
        }
    }
}
