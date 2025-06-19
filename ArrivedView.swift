import SwiftUI

struct ArrivedView: View {
    var duration: String
    var distance: String
    var arrivalTime: String
    var onStartTimer: () -> Void

    var body: some View {
        VStack {
            Spacer()

            VStack(spacing: 16) {
                Text("Arrived at Parking")
                    .font(.title2)
                    .bold()

                VStack(alignment: .leading, spacing: 8) {
                    Text("🕒 Time taken: \(duration)")
                    Text("📍 Distance travelled: \(distance)")
                    Text("🕰️ Arrived at: \(arrivalTime)")
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.subheadline)

                Button(action: onStartTimer) {
                    Text("Start Parking Timer")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                }
            }
            .padding()
            .background(Color(UIColor.systemBackground))
            .cornerRadius(20)
            .shadow(radius: 5)
            .padding(.horizontal)
            .padding(.bottom, 30)
        }
        .transition(.move(edge: .bottom))
    }
}
