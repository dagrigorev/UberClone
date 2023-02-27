//
//  UberCloneApp.swift
//  UberClone
//
//  Created by Dmitry Grigorev on 27.02.2023.
//

import SwiftUI

@main
struct UberCloneApp: App {
    @StateObject var locationSearchViewModel = LocationSearchViewModel()

    var body: some Scene {
        WindowGroup {
            HomeView()
                .environmentObject(locationSearchViewModel)
        }
    }
}
