import SwiftUI
import MapKit

struct RouteStepView: View {
    let step: MKRoute.Step?

    var body: some View {
        if let step = step {
            VStack {
                Text(step.instructions)
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.black.opacity(0.85))
                    .cornerRadius(12)
                    .padding(.top, 60)
                    .padding(.horizontal)
                Spacer()
            }
            .transition(.move(edge: .top))
            .animation(.easeInOut, value: step.instructions)
        }
    }
}
