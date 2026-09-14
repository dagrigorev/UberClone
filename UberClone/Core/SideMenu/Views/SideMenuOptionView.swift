//
//  SideMenuOptionView.swift
//  UberClone
//

import SwiftUI

struct SideMenuOptionView: View {
    let viewModel: SideMenuOptionViewModel

    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: viewModel.imageName)
                .font(.title3)
                .frame(width: 24)

            Text(viewModel.title)
                .font(.system(size: 16, weight: .semibold))

            Spacer()
        }
        .foregroundColor(Color.theme.primaryTextColor)
        .padding(.horizontal)
        .frame(height: 44)
    }
}

struct SideMenuOptionView_Previews: PreviewProvider {
    static var previews: some View {
        SideMenuOptionView(viewModel: .trips)
    }
}
