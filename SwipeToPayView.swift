import SwiftUI
import AVFoundation

struct SwipeToPayView: View {
    let locationName: String
    let durationInMinutes: Int
    let totalCost: Double
    let startTime: Date
    let endTime: Date

    @Binding var isPresented: Bool
    @State private var offset: CGFloat = 0
    @State private var confirmed = false
    private let swipeThreshold: CGFloat = 180
    private let maxSwipeOffset: CGFloat = UIScreen.main.bounds.width - 100
    @AppStorage("isNightMode") private var isNightMode = false

    var body: some View {
        ZStack {
            backgroundGradient.ignoresSafeArea()

            if confirmed {
                PaymentSuccessView(isPresented: $isPresented)
            } else {
                VStack(spacing: 24) {
                    Spacer()

                    Text("Parking Summary")
                        .font(.title)
                        .bold()
                        .foregroundColor(ColorTheme.primaryText(isNightMode: isNightMode))

                    VStack(spacing: 8) {
                        Text("📍 Location: \(locationName)")
                        Text("⏱️ Duration: \(durationInMinutes) min")
                        Text("💰 Cost: £\(String(format: "%.2f", totalCost))")
                    }
                    .font(.subheadline)
                    .foregroundColor(ColorTheme.primaryText(isNightMode: isNightMode))

                    Spacer()

                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 30)
                            .strokeBorder(Color.gray.opacity(0.25), lineWidth: 1)
                            .background(Color.white.opacity(0.9))
                            .cornerRadius(30)
                            .frame(height: 60)
                            .shadow(radius: 2)

                        HStack {
                            Spacer()
                            Text("Swipe to Pay")
                                .foregroundColor(.gray)
                                .font(.subheadline)
                                .opacity(1.0 - Double(offset / maxSwipeOffset))
                            Spacer()
                        }

                        RoundedRectangle(cornerRadius: 30)
                            .fill(Color.white)
                            .frame(width: 60, height: 60)
                            .shadow(color: .black.opacity(0.1), radius: 3, x: 0, y: 2)
                            .overlay(
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.black)
                                    .font(.system(size: 24, weight: .bold))
                            )
                            .offset(x: offset)
                            .gesture(
                                DragGesture()
                                    .onChanged { gesture in
                                        if gesture.translation.width > 0 {
                                            offset = min(gesture.translation.width, maxSwipeOffset - 60)
                                        }
                                    }
                                    .onEnded { _ in
                                        if offset > swipeThreshold {
                                            confirmPayment()
                                        } else {
                                            withAnimation(.spring()) {
                                                offset = 0
                                            }
                                        }
                                    }
                            )
                            .padding(.leading, 4)
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 40)
                }
                .padding()
            }
        }
    }

    private var backgroundGradient: Color {
        let progress = min(offset / maxSwipeOffset, 1.0)

        let lightStart = UIColor.white.components
        let lightEnd = UIColor.systemPink.components
        let darkStart = UIColor.black.components
        let darkEnd = UIColor.systemRed.components

        let start = isNightMode ? darkStart : lightStart
        let end = isNightMode ? darkEnd : lightEnd

        return Color(
            red: Double(1.0 - progress) * start.red + Double(progress) * end.red,
            green: Double(1.0 - progress) * start.green + Double(progress) * end.green,
            blue: Double(1.0 - progress) * start.blue + Double(progress) * end.blue
        )
    }

    private func confirmPayment() {
        playPingSound()

        PaymentManager.shared.addPayment(
            locationName: locationName,
            startTime: startTime,
            endTime: endTime,
            duration: durationInMinutes,
            totalCost: totalCost
        )

        withAnimation(.spring()) {
            confirmed = true
        }
    }

    private func playPingSound() {
        if let soundURL = Bundle.main.url(forResource: "ping", withExtension: "mp3") {
            var soundPlayer: AVAudioPlayer?
            do {
                soundPlayer = try AVAudioPlayer(contentsOf: soundURL)
                soundPlayer?.play()
            } catch {
                print("Failed to play ping sound.")
            }
        }
    }
}
