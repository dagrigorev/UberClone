//
//  SideMenuView.swift
//  UberClone
//

import SwiftUI

struct SideMenuView: View {
    @EnvironmentObject var userViewModel: UserViewModel
    @State private var selectedOption: SideMenuOptionViewModel?

    var body: some View {
        VStack(alignment: .leading, spacing: 32) {
            // user info header
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    Text(userViewModel.currentUser.initials)
                        .font(.title)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .frame(width: 64, height: 64)
                        .background(Color(.systemGray3))
                        .clipShape(Circle())

                    VStack(alignment: .leading, spacing: 6) {
                        Text(userViewModel.currentUser.fullname)
                            .font(.system(size: 18, weight: .semibold))

                        Text(userViewModel.currentUser.email)
                            .font(.footnote)
                            .foregroundColor(Color.theme.secondaryTextColor)
                    }
                }

                HStack(spacing: 24) {
                    Label("Do more", systemImage: "square.grid.2x2")
                    Label("Safety", systemImage: "shield")
                }
                .font(.footnote)
                .foregroundColor(Color.theme.secondaryTextColor)
            }
            .padding(.horizontal)
            .padding(.top, 64)

            Divider()

            // option list
            VStack(alignment: .leading, spacing: 4) {
                ForEach(SideMenuOptionViewModel.allCases) { option in
                    NavigationLink(value: option) {
                        SideMenuOptionView(viewModel: option)
                    }
                }
            }

            Spacer()

            // saved places
            VStack(alignment: .leading, spacing: 12) {
                Text("SAVED PLACES")
                    .font(.caption)
                    .foregroundColor(Color.theme.secondaryTextColor)

                Label(userViewModel.currentUser.homeLocation ?? "Add home", systemImage: "house")
                    .font(.footnote)

                Label(userViewModel.currentUser.workLocation ?? "Add work", systemImage: "briefcase")
                    .font(.footnote)
            }
            .padding(.horizontal)
            .padding(.bottom, 48)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
        .background(Color.theme.backgroundColor)
        .navigationDestination(for: SideMenuOptionViewModel.self) { option in
            SideMenuDetailView(option: option)
        }
    }
}

/// Lightweight placeholder destination for each menu entry.
struct SideMenuDetailView: View {
    let option: SideMenuOptionViewModel
    @EnvironmentObject var userViewModel: UserViewModel

    var body: some View {
        List {
            switch option {
            case .trips:
                Section("Recent") {
                    Text("No trips yet — request a ride to see it here.")
                        .foregroundColor(Color.theme.secondaryTextColor)
                }
            case .wallet:
                Section("Payment methods") {
                    Label("Visa •••• 1234", systemImage: "creditcard")
                    Label("Add payment method", systemImage: "plus.circle")
                }
            case .settings:
                Section("Account") {
                    LabeledContent("Name", value: userViewModel.currentUser.fullname)
                    LabeledContent("Email", value: userViewModel.currentUser.email)
                    LabeledContent("Home", value: userViewModel.currentUser.homeLocation ?? "Not set")
                    LabeledContent("Work", value: userViewModel.currentUser.workLocation ?? "Not set")
                }
            case .messages:
                Section("Inbox") {
                    Text("You have no new messages.")
                        .foregroundColor(Color.theme.secondaryTextColor)
                }
            }
        }
        .navigationTitle(option.title)
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct SideMenuView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            SideMenuView()
                .environmentObject(UserViewModel())
        }
    }
}
