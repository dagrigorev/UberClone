//
//  TripAcceptedView.swift
//  UberClone
//

import SwiftUI

/// Driver-matched sheet: who is coming, in what, and how far out they are.
struct TripAcceptedView: View {
    @Binding var mapState: MapViewState
    @EnvironmentObject var locationViewModel: LocationSearchViewModel

    private var driver: Driver? { locationViewModel.nearbyDrivers.first }

    var body: some View {
        VStack(spacing: 12) {
            Capsule()
                .foregroundColor(Color(.systemGray5))
                .frame(width: 48, height: 6)
                .padding(.top, 8)

            HStack {
                Text("Meet your driver at \(locationViewModel.pickupTime ?? "the pickup point")")
                    .font(.headline)
                    .frame(maxWidth: .infinity, alignment: .leading)

                Spacer()

                VStack {
                    Text("\(locationViewModel.trip?.travelTimeToPassenger ?? 5)")
                        .bold()
                    Text("min")
                        .bold()
                }
                .frame(width: 56, height: 56)
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
            }
            .padding(.horizontal)

            Divider()

            HStack {
                Image(systemName: "person.crop.circle.fill")
                    .resizable()
                    .frame(width: 56, height: 56)
                    .foregroundColor(Color.theme.secondaryTextColor)

                VStack(alignment: .leading, spacing: 4) {
                    Text(driver?.fullname ?? "Your driver")
                        .fontWeight(.bold)

                    HStack {
                        Image(systemName: "star.fill")
                            .resizable()
                            .frame(width: 14, height: 14)
                            .foregroundColor(.yellow)

                        Text(String(format: "%.1f", driver?.rating ?? 4.8))
                            .font(.footnote)
                            .foregroundColor(Color.theme.secondaryTextColor)
                    }
                }

                Spacer()

                VStack(alignment: .trailing, spacing: 4) {
                    Text(driver?.licensePlate ?? "------")
                        .font(.system(size: 14, weight: .semibold))
                        .padding(6)
                        .background(Color.theme.secondaryBackgroundColor)
                        .cornerRadius(6)

                    Text(driver?.carDescription ?? "")
                        .font(.footnote)
                        .foregroundColor(Color.theme.secondaryTextColor)
                }
            }
            .padding(.horizontal)

            Divider()

            HStack(spacing: 24) {
                ContactActionButton(systemImage: "phone.fill", title: "Call")
                ContactActionButton(systemImage: "message.fill", title: "Message")
                ContactActionButton(systemImage: "shield.fill", title: "Safety")
            }
            .padding(.vertical, 4)

            Divider()

            Button {
                withAnimation(.spring()) {
                    locationViewModel.updateTripState(.cancelled)
                    mapState = .tripCancelled
                }
            } label: {
                Text("CANCEL TRIP")
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .frame(width: UIScreen.main.bounds.width - 32, height: 50)
                    .background(.red)
                    .cornerRadius(10)
            }
            .padding(.bottom, 24)
        }
        .background(Color.theme.backgroundColor)
        .cornerRadius(16, corners: [.topLeft, .topRight])
        .shadow(color: .black.opacity(0.2), radius: 8)
        .onAppear {
            // Simulated pickup: the driver arrives and the ride starts.
            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                guard mapState == .tripAccepted else { return }
                withAnimation(.spring()) {
                    locationViewModel.updateTripState(.inProgress)
                    mapState = .tripInProgress
                }
            }
        }
    }
}

private struct ContactActionButton: View {
    let systemImage: String
    let title: String

    var body: some View {
        VStack(spacing: 6) {
            Image(systemName: systemImage)
                .font(.title3)
                .foregroundColor(Color.theme.primaryTextColor)
                .frame(width: 44, height: 44)
                .background(Color.theme.secondaryBackgroundColor)
                .clipShape(Circle())

            Text(title)
                .font(.caption)
                .foregroundColor(Color.theme.secondaryTextColor)
        }
    }
}

struct TripAcceptedView_Previews: PreviewProvider {
    static var previews: some View {
        TripAcceptedView(mapState: .constant(.tripAccepted))
            .environmentObject(LocationSearchViewModel())
    }
}
