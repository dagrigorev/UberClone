//
//  UberMapViewPresenter.swift
//  UberClone
//
//  Created by Dmitry Grigorev on 27.02.2023.
//

import SwiftUI
import MapKit

struct UberMapViewPresenter: UIViewRepresentable {
    typealias UIViewType = UIView

    let mkMapView = MKMapView()
    let locationManager = LocationManager()

    func makeUIView(context: Context) -> UIView {
        // set coordinator as base coordinate calculation delegate
        mkMapView.delegate = context.coordinator
        mkMapView.isRotateEnabled = false
        mkMapView.showsUserLocation = true
        
        // the map will `follow` by user
        mkMapView.userTrackingMode = .follow
            
        return mkMapView;
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        
    }
    
    func makeCoordinator() -> MkMapCoordinator {
        return MkMapCoordinator(parent: self)
    }
}

extension UberMapViewPresenter {
    class MkMapCoordinator: NSObject, MKMapViewDelegate {
        let parent: UberMapViewPresenter
        
        init(parent: UberMapViewPresenter) {
            self.parent = parent
            super.init()
        }
        
        func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
            // create user location region
            let locationRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude), span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
            )
            
            // set user location region on map view
            parent.mkMapView.setRegion(locationRegion, animated: true)
        }
    }
}
