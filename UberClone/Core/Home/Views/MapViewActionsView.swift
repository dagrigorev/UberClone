//
//  MapViewActionsView.swift
//  UberClone
//
//  Created by Dmitry Grigorev on 27.02.2023.
//

import SwiftUI

struct MapViewActionsView: View {
    @Binding var mapState: MapViewState
    @EnvironmentObject var viewModel: LocationSearchViewModel
    /// Opens the side menu when the button is showing the hamburger icon.
    var onMenuTap: () -> Void = {}

    var body: some View {
        Button {
            withAnimation(.spring()) {
                actionForState(mapState)
            }
        } label: {
            Image(systemName: imageNameForState(mapState))
                .font(.title2)
                .foregroundColor(.black)
                .padding()
                .background(.white)
                .clipShape(Circle())
                .shadow(color: .black.opacity(0.6), radius: 6)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private func actionForState(_ state: MapViewState) {
        switch state {
        case .noInput:
            onMenuTap()
        case .searchingForLocation:
            mapState = .noInput
        case .locationSelected, .polylineAdded, .tripCancelled, .tripCompleted:
            mapState = .noInput
            viewModel.clearSelection()
        case .tripRequested, .tripAccepted, .tripInProgress:
            // The back button is hidden during an active trip; nothing to undo here.
            break
        }
    }

    private func imageNameForState(_ state: MapViewState) -> String {
        switch state {
        case .noInput:
            return "line.3.horizontal"
        default:
            return "arrow.left"
        }
    }
}

struct MapViewActionsView_Previews: PreviewProvider {
    static var previews: some View {
        MapViewActionsView(mapState: .constant(.noInput))
            .environmentObject(LocationSearchViewModel())
    }
}
