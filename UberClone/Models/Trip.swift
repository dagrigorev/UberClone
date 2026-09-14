//
//  Trip.swift
//  UberClone
//

import CoreLocation
import Foundation

enum TripState: Int, Codable {
    case requested
    case rejected
    case accepted
    case inProgress
    case arrivedAtDestination
    case completed
    case cancelled
}

struct Trip: Identifiable {
    let id: String
    let passengerName: String
    let driverName: String
    let pickupLocationName: String
    let dropoffLocationName: String
    let pickupCoordinate: CLLocationCoordinate2D
    let dropoffCoordinate: CLLocationCoordinate2D
    let tripCost: Double
    let rideType: RideType
    var state: TripState
    /// Minutes until the driver reaches the pickup point.
    var travelTimeToPassenger: Int
}
