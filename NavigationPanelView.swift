import SwiftUI

struct NavigationPanelView: View {
    var instruction: String
    var progress: Double

    var body: some View {
        VStack {
            Spacer()
            VStack(spacing: 12) {
                Text(instruction)
                    .font(.title2)
                    .multilineTextAlignment(.center)

                ProgressView(value: progress)
                    .progressViewStyle(LinearProgressViewStyle())
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(.ultraThinMaterial)
            .cornerRadius(20)
            .shadow(radius: 4)
            .padding(.horizontal)
            .padding(.bottom, 30)
        }
    }
}
