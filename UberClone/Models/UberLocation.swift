//
//  UberLocation.swift
//  UberClone
//

import CoreLocation

/// A named coordinate the user picked from search or from their current position.
struct UberLocation: Identifiable, Equatable {
    let id = UUID()
    let title: String
    let coordinate: CLLocationCoordinate2D

    static func == (lhs: UberLocation, rhs: UberLocation) -> Bool {
        lhs.title == rhs.title
        && lhs.coordinate.latitude == rhs.coordinate.latitude
        && lhs.coordinate.longitude == rhs.coordinate.longitude
    }
}
