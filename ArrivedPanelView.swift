import SwiftUI

struct ArrivedPanelView: View {
    let arrivalTime: Date
    let travelDuration: TimeInterval
    let distanceInMiles: Double
    let onStartParking: () -> Void

    @AppStorage("isNightMode") private var isNightMode = false

    var body: some View {
        ZStack {
            ColorTheme.primaryBackground(isNightMode: isNightMode)
                .ignoresSafeArea()

            VStack(spacing: 28) {
                Spacer()

                Text("You've Arrived 🚗")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                    .foregroundColor(ColorTheme.primaryText(isNightMode: isNightMode))

                VStack(spacing: 16) {
                    StatRow(label: "Arrival Time", value: dateString(from: arrivalTime), isNightMode: isNightMode)
                    StatRow(label: "Travel Time", value: "\(Int(travelDuration)) seconds", isNightMode: isNightMode)
                    StatRow(label: "Distance", value: String(format: "%.2f miles", distanceInMiles), isNightMode: isNightMode)
                }
                .padding()
                .background(ColorTheme.cardBackground(isNightMode: isNightMode))
                .cornerRadius(16)
                .padding(.horizontal)

                Spacer()

                Button(action: onStartParking) {
                    Text("Start Parking Timer")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                        .padding(.horizontal)
                }

                Spacer()
            }
            .padding()
        }
    }

    private func dateString(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

private struct StatRow: View {
    var label: String
    var value: String
    var isNightMode: Bool

    var body: some View {
        HStack {
            Text(label + ":")
                .foregroundColor(.gray)
            Spacer()
            Text(value)
                .fontWeight(.medium)
                .foregroundColor(ColorTheme.primaryText(isNightMode: isNightMode))
        }
        .font(.body)
    }
}
