//
//  LocationSearchResultView.swift
//  UberClone
//
//  Created by Dmitry Grigorev on 27.02.2023.
//

import SwiftUI

struct LocationSearchResultView: View {
    let title: String
    let subtitle: String
    
    var body: some View {
        HStack {
            Image(systemName: "mappin.circle.fill")
                .resizable()
                .foregroundColor(.blue)
                .accentColor(.white)
                .frame(width: 45, height: 45)
            
            VStack (alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.body)
                
                Text(subtitle)
                    .font(.system(size: 15))
                    .foregroundColor(.gray)
                
                Divider()
            }
            .padding(.leading, 8)
            .padding(.vertical, 5)
        }
        .padding(.leading)
    }
}

struct LocationSearchResultView_Previews: PreviewProvider {
    static var previews: some View {
        LocationSearchResultView(title: "Apple Store", subtitle: "123 Bla bla bla")
    }
}
