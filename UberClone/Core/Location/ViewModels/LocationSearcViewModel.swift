//
//  LocationSearcViewModel.swift
//  UberClone
//
//  Created by Dmitry Grigorev on 27.02.2023.
//

import Combine
import Foundation
import MapKit

class LocationSearchViewModel: NSObject, ObservableObject {

    // MARK: Properties

    @Published var results = [MKLocalSearchCompletion]()
    @Published var selectedUberLocation: UberLocation?
    @Published var pickupTime: String?
    @Published var dropOffTime: String?
    @Published var nearbyDrivers = [Driver]()
    @Published var trip: Trip?

    /// Straight-line fallback is only used when MapKit cannot produce a route.
    private(set) var routeDistanceInMeters: Double = 0
    private(set) var routeTravelTime: TimeInterval = 0

    /// Current position, kept in sync from `HomeView` so the view model can build routes.
    var userLocation: CLLocationCoordinate2D?

    private let searchCompleter = MKLocalSearchCompleter()
    private var cancellables = Set<AnyCancellable>()

    var queryFragment: String = "" {
        didSet {
            searchCompleter.queryFragment = queryFragment
        }
    }

    override init() {
        super.init()
        searchCompleter.delegate = self
        searchCompleter.resultTypes = .address
        searchCompleter.queryFragment = queryFragment

        // Keep the pickup coordinate current without every view having to observe CoreLocation.
        LocationManager.shared.$userLocation
            .receive(on: DispatchQueue.main)
            .sink { [weak self] coordinate in
                guard let self, let coordinate else { return }
                self.userLocation = coordinate
                if self.nearbyDrivers.isEmpty {
                    self.nearbyDrivers = Driver.mockDrivers(near: coordinate)
                }
            }
            .store(in: &cancellables)
    }

    // MARK: - Location selection

    func selectLocation(_ localSearch: MKLocalSearchCompletion) {
        locationSearch(forLocalSearchCompletion: localSearch) { [weak self] response, error in
            guard let self else { return }

            if let error {
                print("DEBUG: Location search failed with error \(error.localizedDescription)")
                return
            }

            guard let item = response?.mapItems.first else { return }
            let coordinate = item.placemark.coordinate

            // MKLocalSearch may call back off the main queue; @Published writes must not.
            DispatchQueue.main.async {
                self.selectedUberLocation = UberLocation(title: localSearch.title, coordinate: coordinate)
                self.computeRouteDetails(to: coordinate)
            }
        }
    }

    func clearSelection() {
        selectedUberLocation = nil
        pickupTime = nil
        dropOffTime = nil
        routeDistanceInMeters = 0
        routeTravelTime = 0
        trip = nil
        queryFragment = ""
        results = []
    }

    private func locationSearch(
        forLocalSearchCompletion localSearch: MKLocalSearchCompletion,
        completion: @escaping MKLocalSearch.CompletionHandler
    ) {
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = localSearch.title.appending(" \(localSearch.subtitle)")
        MKLocalSearch(request: searchRequest).start(completionHandler: completion)
    }

    // MARK: - Routing

    func getDestinationRoute(
        from userLocation: CLLocationCoordinate2D,
        to destination: CLLocationCoordinate2D,
        completion: @escaping (MKRoute) -> Void
    ) {
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: userLocation))
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: destination))
        request.transportType = .automobile

        MKDirections(request: request).calculate { response, error in
            if let error {
                print("DEBUG: Route calculation failed with error \(error.localizedDescription)")
                return
            }

            guard let route = response?.routes.first else { return }
            completion(route)
        }
    }

    private func computeRouteDetails(to destination: CLLocationCoordinate2D) {
        guard let userLocation else { return }

        getDestinationRoute(from: userLocation, to: destination) { [weak self] route in
            guard let self else { return }
            DispatchQueue.main.async {
                self.routeDistanceInMeters = route.distance
                self.routeTravelTime = route.expectedTravelTime
                self.configureTimes(expectedTravelTime: route.expectedTravelTime)
            }
        }
    }

    private func configureTimes(expectedTravelTime: TimeInterval) {
        // Pickup is assumed to be a short hop away; drop-off follows the routed travel time.
        let pickup = Date().addingTimeInterval(5 * 60)
        pickupTime = pickup.toTimeString()
        dropOffTime = pickup.addingTimeInterval(expectedTravelTime).toTimeString()
    }

    // MARK: - Pricing

    func computeRidePrice(forType type: RideType) -> Double {
        guard let destination = selectedUberLocation?.coordinate else { return 0 }

        let distance: Double
        if routeDistanceInMeters > 0 {
            distance = routeDistanceInMeters
        } else if let userLocation {
            distance = userLocation.distance(to: destination)
        } else {
            distance = 0
        }

        return type.computePrice(for: distance)
    }

    // MARK: - Trips

    /// Creates the local trip record shown while the ride is being matched.
    func requestTrip(rideType: RideType, user: User) {
        guard let destination = selectedUberLocation, let userLocation else { return }
        let driver = nearbyDrivers.first ?? Driver.mockDrivers(near: userLocation)[0]

        trip = Trip(
            id: NSUUID().uuidString,
            passengerName: user.fullname,
            driverName: driver.fullname,
            pickupLocationName: "Current Location",
            dropoffLocationName: destination.title,
            pickupCoordinate: userLocation,
            dropoffCoordinate: destination.coordinate,
            tripCost: computeRidePrice(forType: rideType),
            rideType: rideType,
            state: .requested,
            travelTimeToPassenger: 5
        )
    }

    func updateTripState(_ state: TripState) {
        trip?.state = state
    }
}

// MARK: - MKLocalSearchCompleterDelegate

extension LocationSearchViewModel: MKLocalSearchCompleterDelegate {
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        // when search was completed set the results
        self.results = completer.results
    }

    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        print("DEBUG: Search completer failed with error \(error.localizedDescription)")
    }
}
