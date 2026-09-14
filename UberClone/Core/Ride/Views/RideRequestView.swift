//
//  RideRequestView.swift
//  UberClone
//

import SwiftUI

struct RideRequestView: View {
    @State private var selectedRideType: RideType = .uberX
    @Binding var mapState: MapViewState
    @EnvironmentObject var locationViewModel: LocationSearchViewModel
    @EnvironmentObject var userViewModel: UserViewModel

    var body: some View {
        VStack {
            Capsule()
                .foregroundColor(Color(.systemGray5))
                .frame(width: 48, height: 6)
                .padding(.top, 8)

            // trip info
            HStack {
                VStack {
                    Circle()
                        .fill(Color(.systemGray3))
                        .frame(width: 8, height: 8)

                    Rectangle()
                        .fill(Color(.systemGray3))
                        .frame(width: 1, height: 32)

                    Rectangle()
                        .fill(Color.theme.primaryTextColor)
                        .frame(width: 8, height: 8)
                }

                VStack(alignment: .leading, spacing: 24) {
                    HStack {
                        Text("Current location")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(Color.theme.secondaryTextColor)

                        Spacer()

                        Text(locationViewModel.pickupTime ?? "--:--")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(Color.theme.secondaryTextColor)
                    }

                    HStack {
                        Text(locationViewModel.selectedUberLocation?.title ?? "Destination")
                            .font(.system(size: 16, weight: .semibold))
                            .lineLimit(1)

                        Spacer()

                        Text(locationViewModel.dropOffTime ?? "--:--")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(Color.theme.secondaryTextColor)
                    }
                }
                .padding(.leading, 8)
            }
            .padding()

            Divider()

            Text("SUGGESTED RIDES")
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(Color.theme.secondaryTextColor)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()

            // ride type list
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(RideType.allCases) { type in
                        RideTypeCell(
                            type: type,
                            price: locationViewModel.computeRidePrice(forType: type),
                            isSelected: type == selectedRideType
                        )
                        .onTapGesture {
                            withAnimation(.spring()) { selectedRideType = type }
                        }
                    }
                }
                .padding(.horizontal)
            }

            Divider()
                .padding(.vertical, 8)

            // payment row
            HStack(spacing: 12) {
                Text("Visa")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .padding(6)
                    .background(.blue)
                    .cornerRadius(4)
                    .foregroundColor(.white)
                    .padding(.leading)

                Text("**** 1234")
                    .fontWeight(.bold)

                Spacer()

                Image(systemName: "chevron.right")
                    .imageScale(.medium)
                    .padding()
            }
            .frame(height: 50)
            .background(Color.theme.secondaryBackgroundColor)
            .cornerRadius(10)
            .padding(.horizontal)

            // request button
            Button {
                withAnimation(.spring()) {
                    locationViewModel.requestTrip(rideType: selectedRideType, user: userViewModel.currentUser)
                    mapState = .tripRequested
                }
            } label: {
                Text("CONFIRM \(selectedRideType.description.uppercased())")
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

private struct RideTypeCell: View {
    let type: RideType
    let price: Double
    let isSelected: Bool

    var body: some View {
        VStack(alignment: .leading) {
            Image(systemName: type.systemImageName)
                .resizable()
                .scaledToFit()
                .frame(height: 44)
                .padding(.horizontal, 8)
                .foregroundColor(isSelected ? .white : Color.theme.primaryTextColor)

            VStack(alignment: .leading, spacing: 4) {
                Text(type.description)
                    .font(.system(size: 14, weight: .semibold))

                Text(price.toCurrency())
                    .font(.system(size: 14, weight: .semibold))
            }
            .padding(8)
        }
        .frame(width: 112, height: 140)
        .foregroundColor(isSelected ? .white : Color.theme.primaryTextColor)
        .background(isSelected ? Color.blue : Color.theme.secondaryBackgroundColor)
        .scaleEffect(isSelected ? 1.05 : 1.0)
        .cornerRadius(10)
    }
}

struct RideRequestView_Previews: PreviewProvider {
    static var previews: some View {
        RideRequestView(mapState: .constant(.polylineAdded))
            .environmentObject(LocationSearchViewModel())
            .environmentObject(UserViewModel())
    }
}
