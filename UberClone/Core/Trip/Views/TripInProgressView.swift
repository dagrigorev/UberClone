//
//  TripInProgressView.swift
//  UberClone
//

import SwiftUI

/// En-route sheet shown between pickup and drop-off.
struct TripInProgressView: View {
    @Binding var mapState: MapViewState
    @EnvironmentObject var locationViewModel: LocationSearchViewModel

    var body: some View {
        VStack(spacing: 12) {
            Capsule()
                .foregroundColor(Color(.systemGray5))
                .frame(width: 48, height: 6)
                .padding(.top, 8)

            Text("En route to destination")
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)

            Divider()

            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Arriving at")
                        .font(.footnote)
                        .foregroundColor(Color.theme.secondaryTextColor)

                    Text(locationViewModel.selectedUberLocation?.title ?? "Destination")
                        .fontWeight(.semibold)
                        .lineLimit(1)
                }

                Spacer()

                VStack(alignment: .trailing, spacing: 4) {
                    Text("ETA")
                        .font(.footnote)
                        .foregroundColor(Color.theme.secondaryTextColor)

                    Text(locationViewModel.dropOffTime ?? "--:--")
                        .fontWeight(.semibold)
                }
            }
            .padding(.horizontal)

            Divider()

            HStack {
                Text("Trip total")
                    .foregroundColor(Color.theme.secondaryTextColor)

                Spacer()

                Text((locationViewModel.trip?.tripCost ?? 0).toCurrency())
                    .fontWeight(.bold)
            }
            .padding(.horizontal)

            Button {
                withAnimation(.spring()) {
                    locationViewModel.updateTripState(.completed)
                    mapState = .tripCompleted
                }
            } label: {
                Text("END TRIP")
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

struct TripInProgressView_Previews: PreviewProvider {
    static var previews: some View {
        TripInProgressView(mapState: .constant(.tripInProgress))
            .environmentObject(LocationSearchViewModel())
    }
}
