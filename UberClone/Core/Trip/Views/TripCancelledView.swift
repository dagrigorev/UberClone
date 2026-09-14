//
//  TripCancelledView.swift
//  UberClone
//

import SwiftUI

struct TripCancelledView: View {
    @Binding var mapState: MapViewState
    @EnvironmentObject var locationViewModel: LocationSearchViewModel

    var body: some View {
        VStack(spacing: 12) {
            Capsule()
                .foregroundColor(Color(.systemGray5))
                .frame(width: 48, height: 6)
                .padding(.top, 8)

            Text("Your trip was cancelled")
                .font(.headline)

            Text("No charge was applied to your account.")
                .font(.subheadline)
                .foregroundColor(Color.theme.secondaryTextColor)

            Button {
                withAnimation(.spring()) {
                    locationViewModel.clearSelection()
                    mapState = .noInput
                }
            } label: {
                Text("OK")
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .frame(width: UIScreen.main.bounds.width - 32, height: 50)
                    .background(Color.theme.primaryTextColor)
                    .cornerRadius(10)
            }
            .padding(.top, 8)
            .padding(.bottom, 24)
        }
        .background(Color.theme.backgroundColor)
        .cornerRadius(16, corners: [.topLeft, .topRight])
        .shadow(color: .black.opacity(0.2), radius: 8)
    }
}

struct TripCancelledView_Previews: PreviewProvider {
    static var previews: some View {
        TripCancelledView(mapState: .constant(.tripCancelled))
            .environmentObject(LocationSearchViewModel())
    }
}
