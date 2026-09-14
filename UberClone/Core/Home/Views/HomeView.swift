//
//  HomeView.swift
//  UberClone
//
//  Created by Dmitry Grigorev on 27.02.2023.
//

import SwiftUI

struct HomeView: View {
    @State private var mapState = MapViewState.noInput
    @State private var showSideMenu = false
    @EnvironmentObject var locationViewModel: LocationSearchViewModel
    @EnvironmentObject var userViewModel: UserViewModel

    private var sideMenuWidth: CGFloat { min(300, UIScreen.main.bounds.width * 0.78) }

    var body: some View {
        ZStack(alignment: .leading) {
            mapContent

            if showSideMenu {
                Color.black.opacity(0.25)
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation(.spring()) { showSideMenu = false }
                    }

                NavigationStack {
                    SideMenuView()
                }
                .frame(width: sideMenuWidth)
                .ignoresSafeArea()
                .transition(.move(edge: .leading))
                .shadow(color: .black.opacity(0.3), radius: 10)
            }
        }
        .onReceive(LocationManager.shared.$userLocation) { location in
            if let location {
                locationViewModel.userLocation = location
            }
        }
    }

    // MARK: - Map + bottom sheets

    private var mapContent: some View {
        ZStack(alignment: .bottom) {
            ZStack(alignment: .top) {
                UberMapViewPresenter(mapState: $mapState)
                    .ignoresSafeArea()

                if mapState == .searchingForLocation {
                    LocationSearchView(mapState: $mapState)
                } else if mapState == .noInput {
                    LocationView()
                        .padding(.top, 72)
                        .onTapGesture {
                            withAnimation(.spring()) {
                                mapState = .searchingForLocation
                            }
                        }
                }

                if !isTripActive {
                    MapViewActionsView(mapState: $mapState) {
                        withAnimation(.spring()) { showSideMenu = true }
                    }
                    .padding(.leading)
                    .padding(.top, 4)
                }
            }

            bottomSheet
        }
        .ignoresSafeArea(edges: .bottom)
    }

    @ViewBuilder
    private var bottomSheet: some View {
        switch mapState {
        case .locationSelected, .polylineAdded:
            RideRequestView(mapState: $mapState)
                .transition(.move(edge: .bottom))
        case .tripRequested:
            TripLoadingView(mapState: $mapState)
                .transition(.move(edge: .bottom))
        case .tripAccepted:
            TripAcceptedView(mapState: $mapState)
                .transition(.move(edge: .bottom))
        case .tripInProgress:
            TripInProgressView(mapState: $mapState)
                .transition(.move(edge: .bottom))
        case .tripCompleted:
            TripCompletedView(mapState: $mapState)
                .transition(.move(edge: .bottom))
        case .tripCancelled:
            TripCancelledView(mapState: $mapState)
                .transition(.move(edge: .bottom))
        case .noInput, .searchingForLocation:
            EmptyView()
        }
    }

    private var isTripActive: Bool {
        switch mapState {
        case .tripRequested, .tripAccepted, .tripInProgress, .tripCompleted:
            return true
        default:
            return false
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environmentObject(LocationSearchViewModel())
            .environmentObject(UserViewModel())
    }
}
