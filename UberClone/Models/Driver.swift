//
//  Driver.swift
//  UberClone
//

import CoreLocation
import Foundation

struct Driver: Identifiable {
    let id: String
    let fullname: String
    let carMake: String
    let carModel: String
    let licensePlate: String
    let rating: Double
    var coordinate: CLLocationCoordinate2D

    var carDescription: String { "\(carMake) \(carModel)" }

    static func mockDrivers(near coordinate: CLLocationCoordinate2D) -> [Driver] {
        let offsets: [(Double, Double)] = [
            (0.008, 0.006), (-0.006, 0.009), (0.011, -0.004), (-0.009, -0.008)
        ]
        let names = ["Alex Morgan", "Priya Nair", "Sam Okafor", "Lena Fischer"]
        let cars = [("Toyota", "Prius"), ("Tesla", "Model 3"), ("Honda", "Civic"), ("Ford", "Explorer")]
        let plates = ["8QKR421", "5TZM908", "3JWD117", "7BLP553"]
        let ratings = [4.9, 4.8, 5.0, 4.7]

        return (0..<offsets.count).map { index in
            Driver(
                id: NSUUID().uuidString,
                fullname: names[index],
                carMake: cars[index].0,
                carModel: cars[index].1,
                licensePlate: plates[index],
                rating: ratings[index],
                coordinate: CLLocationCoordinate2D(
                    latitude: coordinate.latitude + offsets[index].0,
                    longitude: coordinate.longitude + offsets[index].1
                )
            )
        }
    }
}
