//
//  HomeView.swift
//  UberClone
//
//  Created by Dmitry Grigorev on 27.02.2023.
//

import SwiftUI

struct HomeView: View {
    @State private var showLocationView = false
    
    var body: some View {
        ZStack (alignment: .top) {
            UberMapViewPresenter()
                .ignoresSafeArea()
            
            if !showLocationView {
                LocationView()
                    .padding(.top, 72)
                    .onTapGesture {
                        withAnimation(.spring()) {
                            showLocationView.toggle()
                        }
                    }
            } else {
                LocationSearchView()
            }
            
            MapViewActionsView(showLocationSearchView: $showLocationView)
                .padding(.leading)
                .padding(.top, 4)
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
