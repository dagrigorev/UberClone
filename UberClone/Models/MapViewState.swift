//
//  MapViewState.swift
//  UberClone
//

import Foundation

/// Drives what the map and the bottom sheet show at any given moment.
enum MapViewState {
    case noInput
    case searchingForLocation
    case locationSelected
    case polylineAdded
    case tripRequested
    case tripAccepted
    case tripInProgress
    case tripCompleted
    case tripCancelled
}
