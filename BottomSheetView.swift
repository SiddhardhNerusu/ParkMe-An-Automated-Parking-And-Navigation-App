import SwiftUI

struct BottomSheetView: View {
    @Binding var searchText: String
    @Binding var showSearchResults: Bool
    @Binding var selectedPlace: Place?
    @State private var sheetOffset: CGFloat = UIScreen.main.bounds.height * 0.48

    var filteredPlaces: [Place]
    var onSearchTap: () -> Void
    var onPlaceSelect: (Place) -> Void
    var isNightMode: Bool
    var toggleTheme: () -> Void
    var onSettingsTap: () -> Void
    var onFavoriteTap: () -> Void

    @EnvironmentObject var accountManager: AccountManager
    @GestureState private var dragOffset = CGSize.zero

    var body: some View {
        VStack(spacing: 12) {
            RoundedRectangle(cornerRadius: 3)
                .frame(width: 40, height: 6)
                .foregroundColor(.gray.opacity(0.4))
                .padding(.top, 8)

            HStack {
           
                Button(action: onSettingsTap) {
                    if let image = accountManager.currentUser?.profileImage {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 36, height: 36)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(Color.white, lineWidth: 1))
                    } else {
                        Image(systemName: "line.horizontal.3")
                            .font(.title2)
                            .padding(10)
                            .background(Color.gray)
                            .clipShape(Circle())
                            .foregroundColor(.white)
                    }
                }


                Button(action: onFavoriteTap) {
                    Image(systemName: "heart.fill")
                        .font(.title2)
                        .padding()
                        .background(Color.purple)
                        .clipShape(Circle())
                        .foregroundColor(.white)
                }


                TextField("Search", text: $searchText, onEditingChanged: { editing in
                    withAnimation {
                        showSearchResults = editing
                        sheetOffset = editing ? 100 : UIScreen.main.bounds.height * 0.43
                    }
                })
                .padding()
                .background(ColorTheme.searchBarBackground(isNightMode: isNightMode)) 
                .foregroundColor(ColorTheme.primaryText(isNightMode: isNightMode))
                .cornerRadius(12)
                .shadow(radius: 3)

                Button(action: toggleTheme) {
                    Image(systemName: isNightMode ? "sun.max.fill" : "moon.fill")
                        .font(.title2)
                        .padding()
                        .background(Color.blue)
                        .clipShape(Circle())
                        .foregroundColor(.white)
                }
            }
            .padding(.horizontal)


            ScrollView {
                VStack(alignment: .leading, spacing: 10) {
                    ForEach(filteredPlaces) { place in
                        Button {
                            selectedPlace = place
                            onPlaceSelect(place)
                        } label: {
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(place.name)
                                        .font(.headline)
                                        .foregroundColor(ColorTheme.primaryText(isNightMode: isNightMode))

                                    if let dist = place.distanceInMiles {
                                        Text(String(format: "%.1f miles away", dist))
                                            .font(.subheadline)
                                            .foregroundColor(.gray)
                                    }
                                }
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.blue)
                            }
                            .padding(.horizontal)
                        }
                    }
                }
                .padding(.top)
            }
            .frame(maxHeight: UIScreen.main.bounds.height * 0.4)

            Spacer()
        }
        .frame(height: UIScreen.main.bounds.height * 0.55)
        .background(
            ColorTheme.cardBackground(isNightMode: isNightMode)
                .ignoresSafeArea(.all, edges: .bottom)
        )
        .cornerRadius(20)
        .offset(y: sheetOffset + dragOffset.height)
        .gesture(
            DragGesture()
                .updating($dragOffset) { value, state, _ in
                    state = value.translation
                }
                .onEnded { value in
                    let newOffset = sheetOffset + value.translation.height
                    if newOffset > UIScreen.main.bounds.height * 0.44 {
                        sheetOffset = UIScreen.main.bounds.height * 0.48
                        showSearchResults = false
                    } else {
                        sheetOffset = 100
                        showSearchResults = true
                    }
                }
        )
        .animation(.easeInOut, value: sheetOffset)
        .animation(.easeInOut(duration: 0.4), value: isNightMode)
    }
}
