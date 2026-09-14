//
//  LocationManager.swift
//  UberClone
//
//  Created by Dmitry Grigorev on 27.02.2023.
//

import CoreLocation

class LocationManager: NSObject, ObservableObject {
    static let shared = LocationManager()

    private let locationManager = CLLocationManager()

    /// Last known position, shared with the view models that need a pickup point.
    @Published var userLocation: CLLocationCoordinate2D?
    @Published var authorizationStatus: CLAuthorizationStatus = .notDetermined

    override init() {
        super.init()

        // set location manager delegate (see LocationManager exetension below)
        locationManager.delegate = self

        // Uses best location that could be provided by MapKit
        locationManager.desiredAccuracy = kCLLocationAccuracyBest

        // App requests location and premissions
        locationManager.requestWhenInUseAuthorization()

        // Updates user location
        locationManager.startUpdatingLocation()
    }

    func requestLocation() {
        locationManager.startUpdatingLocation()
    }
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        userLocation = location.coordinate
        locationManager.stopUpdatingLocation()
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        authorizationStatus = manager.authorizationStatus

        switch manager.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            manager.startUpdatingLocation()
        default:
            break
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("DEBUG: Location update failed with error \(error.localizedDescription)")
    }
}
