//
//  LocationView.swift
//  UberClone
//
//  Created by Dmitry Grigorev on 27.02.2023.
//

import SwiftUI

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
                .shadow(color: .black, radius: 2)
        )
    }
}

struct LocationView_Previews: PreviewProvider {
    static var previews: some View {
        LocationView()
    }
}
