//
//  MapViewActionsView.swift
//  UberClone
//
//  Created by Dmitry Grigorev on 27.02.2023.
//

import SwiftUI

struct MapViewActionsView: View {
    @Binding var showLocationSearchView: Bool
    
    var body: some View {
        Button{
            withAnimation(.spring()) {
                showLocationSearchView.toggle()
            }
        } label: {
            Image(systemName: showLocationSearchView ? "arrow.left" : "line.3.horizontal")
                .font(.title2)
                .foregroundColor(.black)
                .padding()
                .background(.white)
                .clipShape(Circle())
                .shadow(color: .black, radius: 2)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct MapViewActionsView_Previews: PreviewProvider {
    static var previews: some View {
        MapViewActionsView(showLocationSearchView: .constant(true))
    }
}
