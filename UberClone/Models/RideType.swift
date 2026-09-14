//
//  RideType.swift
//  UberClone
//

import Foundation

enum RideType: Int, CaseIterable, Identifiable {
    case uberX
    case uberBlack
    case uberXL

    var id: Int { rawValue }

    var description: String {
        switch self {
        case .uberX: return "UberX"
        case .uberBlack: return "UberBlack"
        case .uberXL: return "UberXL"
        }
    }

    var imageName: String {
        switch self {
        case .uberX: return "uber-x"
        case .uberBlack: return "uber-black"
        case .uberXL: return "uber-xl"
        }
    }

    /// Fallback SF Symbol so the UI still reads correctly before art is added to the asset catalog.
    var systemImageName: String {
        switch self {
        case .uberX: return "car.fill"
        case .uberBlack: return "car.side.fill"
        case .uberXL: return "bus.fill"
        }
    }

    var baseFare: Double {
        switch self {
        case .uberX: return 5
        case .uberBlack: return 20
        case .uberXL: return 10
        }
    }

    /// Price per mile, applied on top of the base fare.
    private var ratePerMile: Double {
        switch self {
        case .uberX: return 1.5
        case .uberBlack: return 2.5
        case .uberXL: return 2.0
        }
    }

    func computePrice(for distanceInMeters: Double) -> Double {
        let miles = distanceInMeters / 1600
        return baseFare + (miles * ratePerMile)
    }
}
