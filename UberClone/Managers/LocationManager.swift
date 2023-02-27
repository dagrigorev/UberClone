//
//  LocationManager.swift
//  UberClone
//
//  Created by Dmitry Grigorev on 27.02.2023.
//

import CoreLocation

class LocationManager: NSObject, ObservableObject {
    private let locationManager = CLLocationManager()
    
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
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard !locations.isEmpty else { return }
        locationManager.stopUpdatingLocation()
    }
}
