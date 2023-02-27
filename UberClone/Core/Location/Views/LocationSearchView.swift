//
//  LocationSearchView.swift
//  UberClone
//
//  Created by Dmitry Grigorev on 27.02.2023.
//

import SwiftUI

struct LocationSearchView: View {
    @State private var startLocation = ""
    @State private var destinationLocation = ""
    @StateObject var viewModel = LocationSearchViewModel()

    var body: some View {
        VStack {
            // header view
            HStack {
                VStack {
                    Circle()
                        .fill(Color(.systemGray3))
                        .frame(width: 6, height: 6)
                    Rectangle()
                        .fill(Color(.systemGray3))
                        .frame(width: 1, height: 24)

                    Rectangle()
                        .fill(.black)
                        .frame(width: 6, height: 6)
                }

                VStack {
                    TextField("Current location", text: $startLocation)
                        .frame(height: 32)
                        .background(Color(.systemGroupedBackground))
                        .padding(.trailing)
                    
                    TextField("Where to go?", text: $viewModel.queryFragment)
                        .frame(height: 32)
                        .background(Color(.systemGray4))
                        .padding(.trailing)
                }
            }
            .padding(.horizontal)
            .padding(.top, 64)
            
            Divider()
                .padding(.vertical)
            
            // list view
            ScrollView {
                VStack (alignment: .leading) {
                    ForEach(viewModel.results, id: \.self) { result in
                        LocationSearchResultView(title: result.title, subtitle: result.subtitle)
                    }
                }
            }
        }
        .background(.white)
    }
}

struct LocationSearchView_Previews: PreviewProvider {
    static var previews: some View {
        LocationSearchView()
    }
}
