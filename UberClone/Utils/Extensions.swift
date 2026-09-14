//
//  Extensions.swift
//  UberClone
//

import CoreLocation
import MapKit
import SwiftUI

extension Double {
    /// Formats a fare as a localized currency string, e.g. `$12.40`.
    func toCurrency() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 2
        return formatter.string(from: NSNumber(value: self)) ?? "$\(String(format: "%.2f", self))"
    }
}

extension Date {
    /// `4:05 PM` style timestamp used for pickup / drop-off estimates.
    func toTimeString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm a"
        return formatter.string(from: self)
    }
}

extension CLLocationCoordinate2D {
    func distance(to coordinate: CLLocationCoordinate2D) -> CLLocationDistance {
        CLLocation(latitude: latitude, longitude: longitude)
            .distance(from: CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude))
    }
}

extension MKPlacemark {
    /// Street + city, skipping the pieces MapKit leaves nil.
    var addressDescription: String {
        [thoroughfare, locality, administrativeArea]
            .compactMap { $0 }
            .joined(separator: ", ")
    }
}

extension View {
    /// Rounds only the given corners — used for the bottom sheets.
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}
