//
//  TripCompletedView.swift
//  UberClone
//

import SwiftUI

/// Receipt plus driver rating, shown once the ride ends.
struct TripCompletedView: View {
    @Binding var mapState: MapViewState
    @EnvironmentObject var locationViewModel: LocationSearchViewModel
    @State private var rating = 5

    var body: some View {
        VStack(spacing: 12) {
            Capsule()
                .foregroundColor(Color(.systemGray5))
                .frame(width: 48, height: 6)
                .padding(.top, 8)

            Text("You have arrived")
                .font(.headline)

            Text("How was your trip with \(locationViewModel.trip?.driverName ?? "your driver")?")
                .font(.subheadline)
                .foregroundColor(Color.theme.secondaryTextColor)
                .multilineTextAlignment(.center)
                .padding(.horizontal)

            HStack(spacing: 8) {
                ForEach(1...5, id: \.self) { star in
                    Image(systemName: star <= rating ? "star.fill" : "star")
                        .font(.title2)
                        .foregroundColor(.yellow)
                        .onTapGesture { rating = star }
                }
            }
            .padding(.vertical, 4)

            Divider()

            HStack {
                Text("Total charged")
                    .foregroundColor(Color.theme.secondaryTextColor)

                Spacer()

                Text((locationViewModel.trip?.tripCost ?? 0).toCurrency())
                    .fontWeight(.bold)
            }
            .padding(.horizontal)

            Button {
                withAnimation(.spring()) {
                    locationViewModel.clearSelection()
                    mapState = .noInput
                }
            } label: {
                Text("DONE")
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .frame(width: UIScreen.main.bounds.width - 32, height: 50)
                    .background(.blue)
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

struct TripCompletedView_Previews: PreviewProvider {
    static var previews: some View {
        TripCompletedView(mapState: .constant(.tripCompleted))
            .environmentObject(LocationSearchViewModel())
    }
}
