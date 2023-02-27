//
//  HomeView.swift
//  UberClone
//
//  Created by Dmitry Grigorev on 27.02.2023.
//

import SwiftUI

struct HomeView: View {
    @State private var showLocationSearchView = false
    
    var body: some View {
        ZStack (alignment: .top) {
            UberMapViewPresenter()
                .ignoresSafeArea()
            
            if !showLocationSearchView {
                LocationView()
                    .padding(.top, 72)
                    .onTapGesture {
                        withAnimation(.spring()) {
                            showLocationSearchView.toggle()
                        }
                    }
            } else {
                LocationSearchView(showLocationSearchView: $showLocationSearchView)
            }
            
            MapViewActionsView(showLocationSearchView: $showLocationSearchView)
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
