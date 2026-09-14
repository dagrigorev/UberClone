//
//  User.swift
//  UberClone
//

import Foundation

enum AccountType: Int, Codable {
    case passenger
    case driver
}

struct User: Identifiable, Codable {
    let id: String
    let fullname: String
    let email: String
    let accountType: AccountType
    var homeLocation: String?
    var workLocation: String?

    var initials: String {
        let formatter = PersonNameComponentsFormatter()
        guard let components = formatter.personNameComponents(from: fullname) else {
            return String(fullname.prefix(1)).uppercased()
        }
        formatter.style = .abbreviated
        return formatter.string(from: components)
    }

    /// Stand-in account used until a real auth backend is wired up.
    static let mock = User(
        id: NSUUID().uuidString,
        fullname: "Dmitry Grigorev",
        email: "dmitry@example.com",
        accountType: .passenger,
        homeLocation: "Apple Park, Cupertino",
        workLocation: "Infinite Loop, Cupertino"
    )
}
