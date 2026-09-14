//
//  UserViewModel.swift
//  UberClone
//

import Foundation

/// Holds the signed-in user. Backed by a mock account until auth is wired up.
class UserViewModel: ObservableObject {
    @Published var currentUser: User = .mock

    func updateHomeLocation(_ location: String) {
        currentUser.homeLocation = location
    }

    func updateWorkLocation(_ location: String) {
        currentUser.workLocation = location
    }
}
