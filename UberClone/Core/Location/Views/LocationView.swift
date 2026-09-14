//
//  LocationView.swift
//  UberClone
//
//  Created by Dmitry Grigorev on 27.02.2023.
//

import SwiftUI

/// The collapsed "Where to go?" pill that activates the search screen.
struct LocationView: View {
    var body: some View {
        HStack {

            Rectangle()
                .fill(.black)
                .frame(width: 8, height: 8)
                .padding(.horizontal)

            Text("Where to go?")
                .foregroundColor(Color(.darkGray))

            Spacer()
        }
        .frame(width: UIScreen.main.bounds.width - 64,
               height: 50)
        .background(
            Rectangle()
                .fill(Color(.white))
                .shadow(color: .black.opacity(0.3), radius: 4)
        )
    }
}

struct LocationView_Previews: PreviewProvider {
    static var previews: some View {
        LocationView()
    }
}
