//
//  UberCloneApp.swift
//  UberClone
//
//  Created by Dmitry Grigorev on 27.02.2023.
//

import SwiftUI

@main
struct UberCloneApp: App {
    @StateObject private var locationViewModel = LocationSearchViewModel()
    @StateObject private var userViewModel = UserViewModel()

    var body: some Scene {
        WindowGroup {
            HomeView()
                .environmentObject(locationViewModel)
                .environmentObject(userViewModel)
        }
    }
}
