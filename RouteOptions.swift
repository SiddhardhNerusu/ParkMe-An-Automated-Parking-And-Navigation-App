import SwiftUI

struct RouteOptions: View {
    var onSelect: (String) -> Void
    var onClose: () -> Void

    var body: some View {
        VStack(spacing: 20) {
            Text("Select a Route")
                .font(.title2)
                .bold()
                .padding(.top)

            ForEach(["Fastest", "Shortest", "Avoid Tolls"], id: \.self) { option in
                Button(action: {
                    onSelect(option)
                }) {
                    Text(option)
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue.opacity(0.9))
                        .foregroundColor(.white)
                        .cornerRadius(12)
                }
            }

            Button("Cancel") {
                onClose()
            }
            .padding(.top)
        }
        .padding()
        .background(Color(UIColor.systemBackground))
        .cornerRadius(16)
        .shadow(radius: 5)
        .padding(.horizontal)
    }
}
