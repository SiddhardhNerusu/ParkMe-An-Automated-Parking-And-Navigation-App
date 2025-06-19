import SwiftUI

struct ParkingTimerView: View {
    @Binding var isPresented: Bool
    @State private var startTime = Date()
    @State private var elapsedTime: TimeInterval = 0
    @State private var timer: Timer?
    @State private var showSwipeToPay = false

    var locationName: String
    @AppStorage("isNightMode") private var isNightMode = false

    var body: some View {
        NavigationStack {
            ZStack {
                (isNightMode ? Color.black : Color.pink).ignoresSafeArea()

                VStack(spacing: 24) {
                    Spacer()

                    Text("Parking Timer")
                        .font(.title)
                        .bold()
                        .foregroundColor(.white)

                    Text(formattedTime(elapsedTime))
                        .font(.system(size: 48, weight: .medium, design: .monospaced))
                        .foregroundColor(.white)

                    Spacer()

                    Button(action: {
                        stopTimer()
                        showSwipeToPay = true
                    }) {
                        Text("I'm Back")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(12)
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 40)

                    NavigationLink(
                        destination: SwipeToPayView(
                            locationName: locationName,
                            durationInMinutes: max(1, Int(elapsedTime / 60)),
                            totalCost: Double(max(1, Int(elapsedTime / 60))) * 0.50,
                            startTime: startTime,
                            endTime: Date(),
                            isPresented: $isPresented
                        ),
                        isActive: $showSwipeToPay
                    ) {
                        EmptyView()
                    }
                }
            }
            .onAppear {
                startTimer()
            }
            .onDisappear {
                stopTimer()
            }
        }
    }

    private func startTimer() {
        startTime = Date()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            elapsedTime = Date().timeIntervalSince(startTime)
        }
    }

    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }

    private func formattedTime(_ interval: TimeInterval) -> String {
        let minutes = Int(interval) / 60
        let seconds = Int(interval) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}
