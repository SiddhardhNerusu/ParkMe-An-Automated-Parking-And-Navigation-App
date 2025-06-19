import SwiftUI

struct SearchResultsView: View {
    var places: [Place]
    var onSelect: (Place) -> Void

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 10) {
                ForEach(places) { place in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(place.name)
                                .font(.headline)
                            Text(String(format: "%.1f miles away", place.distanceInMiles ?? 0))                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                        Spacer()
                        Button("Confirm") {
                            onSelect(place)
                        }
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                        .background(Color.pink) 
                        .foregroundColor(.white)
                        .cornerRadius(8)
                    }
                    .padding(.horizontal)
                }
            }
            .padding(.top)
        }
        .background(Color(UIColor.systemBackground))
        .cornerRadius(12)
        .padding(.horizontal)
        .transition(.move(edge: .bottom))
    }
}
