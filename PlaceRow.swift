import SwiftUI

struct PlaceRow: View {
    let place: Place

    var body: some View {
        HStack {
            Image(systemName: "location.fill")
                .foregroundColor(.blue)
            VStack(alignment: .leading) {
                Text(place.name)
                    .font(.body)
            }
        }
        .padding(.horizontal)
    }
}
