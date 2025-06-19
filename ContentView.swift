import SwiftUI
import MapKit

struct ContentView: View {
    @EnvironmentObject var accountManager: AccountManager
    @StateObject private var locationManager = LocationManager()
    @StateObject private var googleService = GooglePlacesService()
    @StateObject private var favoritesManager = FavoritesManager()
    @StateObject private var directionsService = DirectionsService()
    @StateObject private var navigationManager = NavigationManager()

    @State private var selectedPlace: Place?
    @State private var confirmedPlaceName: String = "Unknown Location"
    @State private var arrivalDate = Date()
    @State private var durationSeconds: TimeInterval = 0
    @State private var distanceMiles: Double = 0
    @State private var travelStartTime = Date()
    @State private var travelDuration: String = ""
    @State private var travelDistance: String = ""
    @State private var arrivalTime: String = ""
    @State private var showParkingTimer = false
    @State private var selectedRoute: Route?
    @State private var activeRoute: Route?
    @State private var showArrivalScreen = false
    @State private var showFavorites = false
    @State private var searchText = ""
    @State private var showSearchResults = false
    @State private var showSettings = false
    @State private var isNightMode = UserDefaults.standard.bool(forKey: "isNightMode")
    @State private var showRoutePreviewPanel = false

    private func fetchRoute(for place: Place) {
        guard let origin = locationManager.currentLocation else { return }
        directionsService.fetchRoute(from: origin, to: place.coordinate) { route in
            selectedRoute = route
            showRoutePreviewPanel = true
        }
    }

    private var filteredPlaces: [Place] {
        guard let userLoc = locationManager.currentLocation else { return [] }
        let userLocation = CLLocation(latitude: userLoc.latitude, longitude: userLoc.longitude)

        let mappedPlaces = googleService.places.map { place -> Place in
            var updated = place
            let placeLoc = CLLocation(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude)
            let distance = placeLoc.distance(from: userLocation) / 1609.34
            updated.distanceInMiles = distance
            return updated
        }

        return mappedPlaces.sorted { ($0.distanceInMiles ?? 0) < ($1.distanceInMiles ?? 0) }
    }

    private var mapLayer: some View {
        Map(position: $locationManager.mapCameraPosition) {
            if let user = navigationManager.simulatedPosition ?? locationManager.currentLocation {
                Annotation("User", coordinate: user) {
                    Image("car")
                        .resizable()
                        .frame(width: 40, height: 40)
                        .rotationEffect(Angle(degrees: locationManager.heading))
                }
            }

            ForEach(directionsService.routes.prefix(3)) { route in
                MapPolyline(coordinates: route.overviewPolyline)
                    .stroke(route.id == activeRoute?.id ? .blue : .gray, lineWidth: 6)
            }

            ForEach(filteredPlaces) { place in
                Marker(place.name, coordinate: place.coordinate)
                    .tint(.purple)
            }
        }
        .mapStyle(isNightMode ? .imagery(elevation: .realistic) : .standard)
        .gesture(TapGesture().onEnded {
            showRoutePreviewPanel = false
        })
        .ignoresSafeArea()
        .onAppear {
            locationManager.requestLocationManually()
        }
    }

    private var bottomSheet: some View {
        if !showRoutePreviewPanel {
            return AnyView(
                BottomSheetView(
                    searchText: $searchText,
                    showSearchResults: $showSearchResults,
                    selectedPlace: $selectedPlace,
                    filteredPlaces: filteredPlaces,
                    onSearchTap: {
                        showSearchResults = true
                    },
                    onPlaceSelect: { place in
                        selectedPlace = place
                        fetchRoute(for: place)
                        showSearchResults = false
                    },
                    isNightMode: isNightMode,
                    toggleTheme: {
                        withAnimation(.easeInOut(duration: 0.5)) {
                            isNightMode.toggle()
                            UserDefaults.standard.set(isNightMode, forKey: "isNightMode")
                        }
                    },
                    onSettingsTap: {
                        showSettings = true
                    },
                    onFavoriteTap: {
                        showFavorites = true
                    }
                )
            )
        } else {
            return AnyView(EmptyView())
        }
    }

    private var routePreview: some View {
        if let route = selectedRoute, !navigationManager.isNavigating, showRoutePreviewPanel {
            return AnyView(
                RoutePreviewPanel(
                    route: route,
                    onStart: {
                        travelStartTime = Date()
                        confirmedPlaceName = selectedPlace?.name ?? "Unknown Location"

                        navigationManager.onArrival = {
                            let frozenTravelDuration = Date().timeIntervalSince(travelStartTime)
                            durationSeconds = frozenTravelDuration
                            distanceMiles = route.distanceInMeters / 1609.34
                            arrivalDate = Date()
                            showArrivalScreen = true
                        }

                        navigationManager.startNavigationSimulation(to: route.overviewPolyline)
                        activeRoute = route
                        selectedRoute = nil
                        selectedPlace = nil
                        showRoutePreviewPanel = false
                    },
                    selectedPlace: selectedPlace
                )
            )
        } else {
            return AnyView(EmptyView())
        }
    }

    var body: some View {
        ZStack(alignment: .bottom) {
            mapLayer
                .overlay(
                    Group {
                        if navigationManager.isNavigating {
                            HStack {
                                Button(action: {
                                    navigationManager.stopNavigation()
                                    selectedRoute = nil
                                    selectedPlace = nil
                                }) {
                                    Text("End Navigation")
                                        .fontWeight(.bold)
                                        .padding(10)
                                        .background(Color.red)
                                        .foregroundColor(.white)
                                        .cornerRadius(8)
                                }
                                .padding(.leading)
                                .padding(.top, 60)
                                Spacer()
                            }
                        }
                    },
                    alignment: .top
                )

            if navigationManager.isNavigating {
                NavigationPanelView(
                    instruction: navigationManager.currentInstruction,
                    progress: navigationManager.navigationProgress
                )
                .transition(.move(edge: .bottom))
            } else {
                bottomSheet
                    .animation(.easeInOut(duration: 0.4), value: isNightMode)

                routePreview
            }

            if showArrivalScreen {
                ArrivedPanelView(
                    arrivalTime: Date(),
                    travelDuration: durationSeconds,
                    distanceInMiles: distanceMiles
                ) {
                    showArrivalScreen = false
                    showParkingTimer = true
                }
                .transition(.move(edge: .bottom))
            }
        }
        .fullScreenCover(isPresented: $showParkingTimer) {
            ParkingTimerView(
                isPresented: $showParkingTimer,
                locationName: confirmedPlaceName
            )
        }
        .fullScreenCover(isPresented: $showSettings) {
            SettingsView()
                .environmentObject(favoritesManager)
                .environmentObject(navigationManager)
                .environmentObject(directionsService)
        }
        .fullScreenCover(isPresented: $showFavorites) {
            FavoritesView(
                selectedPlace: $selectedPlace,
                selectedRoute: $selectedRoute,
                showRoutePreviewPanel: $showRoutePreviewPanel
            )
            .environmentObject(directionsService)
        }
        .environmentObject(favoritesManager)
        .environmentObject(navigationManager)
        .onChange(of: locationManager.currentLocation) { newLocation in
            if let location = newLocation {
                googleService.fetchNearbyPlaces(latitude: location.latitude, longitude: location.longitude)
            }
        }
    }
}
