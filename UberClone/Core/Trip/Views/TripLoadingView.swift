//
//  TripLoadingView.swift
//  UberClone
//

import SwiftUI

/// Shown while the request is being matched with a nearby driver.
struct TripLoadingView: View {
    @Binding var mapState: MapViewState
    @EnvironmentObject var locationViewModel: LocationSearchViewModel
    @State private var isAnimating = false

    var body: some View {
        VStack(spacing: 12) {
            Capsule()
                .foregroundColor(Color(.systemGray5))
                .frame(width: 48, height: 6)
                .padding(.top, 8)

            HStack {
                VStack(alignment: .leading, spacing: 6) {
                    Text("Connecting you with a driver")
                        .font(.headline)

                    Text("Finding the closest \(locationViewModel.trip?.rideType.description ?? "ride")")
                        .font(.subheadline)
                        .foregroundColor(Color.theme.secondaryTextColor)
                }

                Spacer()

                ProgressView()
                    .scaleEffect(1.4)
            }
            .padding(.horizontal)
            .padding(.top, 8)

            // pulsing placeholder for the matching animation
            Circle()
                .stroke(Color.blue.opacity(0.4), lineWidth: 2)
                .frame(width: 80, height: 80)
                .scaleEffect(isAnimating ? 1.3 : 0.9)
                .opacity(isAnimating ? 0.2 : 1)
                .animation(.easeInOut(duration: 1.2).repeatForever(autoreverses: true), value: isAnimating)
                .padding(.vertical, 8)

            Divider()

            Button {
                withAnimation(.spring()) {
                    locationViewModel.updateTripState(.cancelled)
                    mapState = .tripCancelled
                }
            } label: {
                Text("CANCEL REQUEST")
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
            isAnimating = true
            // No dispatcher backend yet — simulate a driver picking up the request.
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                guard mapState == .tripRequested else { return }
                withAnimation(.spring()) {
                    locationViewModel.updateTripState(.accepted)
                    mapState = .tripAccepted
                }
            }
        }
    }
}

struct TripLoadingView_Previews: PreviewProvider {
    static var previews: some View {
        TripLoadingView(mapState: .constant(.tripRequested))
            .environmentObject(LocationSearchViewModel())
    }
}
