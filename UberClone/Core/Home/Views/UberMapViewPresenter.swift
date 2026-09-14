//
//  UberMapViewPresenter.swift
//  UberClone
//
//  Created by Dmitry Grigorev on 27.02.2023.
//

import MapKit
import SwiftUI

/// Annotation used for the mock drivers circling the user.
class DriverAnnotation: NSObject, MKAnnotation {
    let id: String
    @objc dynamic var coordinate: CLLocationCoordinate2D

    init(driver: Driver) {
        self.id = driver.id
        self.coordinate = driver.coordinate
    }
}

struct UberMapViewPresenter: UIViewRepresentable {
    typealias UIViewType = MKMapView

    let mkMapView = MKMapView()
    @Binding var mapState: MapViewState
    @EnvironmentObject var locationViewModel: LocationSearchViewModel

    func makeUIView(context: Context) -> MKMapView {
        // set coordinator as base coordinate calculation delegate
        mkMapView.delegate = context.coordinator
        mkMapView.isRotateEnabled = false
        mkMapView.showsUserLocation = true

        // the map will `follow` by user
        mkMapView.userTrackingMode = .follow

        return mkMapView
    }

    func updateUIView(_ uiView: MKMapView, context: Context) {
        context.coordinator.showDriverAnnotations(locationViewModel.nearbyDrivers)

        switch mapState {
        case .noInput:
            context.coordinator.clearMapViewAndRecenterOnUserLocation()
        case .searchingForLocation:
            break
        case .locationSelected, .polylineAdded, .tripRequested, .tripAccepted, .tripInProgress:
            if let coordinate = locationViewModel.selectedUberLocation?.coordinate {
                context.coordinator.addAndSelectAnnotation(withCoordinate: coordinate)
                context.coordinator.configurePolyline(withDestinationCoordinate: coordinate)
            }
        case .tripCompleted, .tripCancelled:
            context.coordinator.clearMapViewAndRecenterOnUserLocation()
        }
    }

    func makeCoordinator() -> MkMapCoordinator {
        return MkMapCoordinator(parent: self)
    }
}

extension UberMapViewPresenter {
    class MkMapCoordinator: NSObject, MKMapViewDelegate {

        // MARK: - Properties

        let parent: UberMapViewPresenter
        var userLocationCoordinate: CLLocationCoordinate2D?
        var currentRegion: MKCoordinateRegion?
        private var currentDestination: CLLocationCoordinate2D?
        private var driverAnnotations = [String: DriverAnnotation]()

        init(parent: UberMapViewPresenter) {
            self.parent = parent
            super.init()
        }

        // MARK: - MKMapViewDelegate

        func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
            self.userLocationCoordinate = userLocation.coordinate

            // create user location region
            let locationRegion = MKCoordinateRegion(
                center: CLLocationCoordinate2D(
                    latitude: userLocation.coordinate.latitude,
                    longitude: userLocation.coordinate.longitude
                ),
                span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
            )
            self.currentRegion = locationRegion

            // Only snap back to the user while nothing else is driving the camera.
            guard parent.mapState == .noInput else { return }

            // set user location region on map view
            parent.mkMapView.setRegion(locationRegion, animated: true)
        }

        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            guard let polyline = overlay as? MKPolyline else { return MKOverlayRenderer(overlay: overlay) }
            let renderer = MKPolylineRenderer(polyline: polyline)
            renderer.strokeColor = .systemBlue
            renderer.lineWidth = 6
            return renderer
        }

        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            guard annotation is DriverAnnotation else { return nil }

            let identifier = "driver"
            let view = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
                ?? MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            view.annotation = annotation
            view.image = UIImage(systemName: "car.fill")?
                .withTintColor(.label, renderingMode: .alwaysOriginal)
            return view
        }

        // MARK: - Helpers

        func addAndSelectAnnotation(withCoordinate coordinate: CLLocationCoordinate2D) {
            // Avoid re-adding the pin (and re-zooming) on every SwiftUI update pass.
            guard currentDestination == nil
                    || currentDestination?.latitude != coordinate.latitude
                    || currentDestination?.longitude != coordinate.longitude else { return }

            currentDestination = coordinate
            parent.mkMapView.removeAnnotations(parent.mkMapView.annotations.filter { !($0 is DriverAnnotation) })

            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            parent.mkMapView.addAnnotation(annotation)
            parent.mkMapView.selectAnnotation(annotation, animated: true)
        }

        func configurePolyline(withDestinationCoordinate coordinate: CLLocationCoordinate2D) {
            guard let userLocationCoordinate else { return }
            guard parent.mkMapView.overlays.isEmpty else { return }

            parent.locationViewModel.getDestinationRoute(
                from: userLocationCoordinate,
                to: coordinate
            ) { [weak self] route in
                guard let self else { return }
                self.parent.mkMapView.addOverlay(route.polyline)
                self.parent.mapState = .polylineAdded

                // Leave room for the bottom sheet below the route.
                let rect = self.parent.mkMapView.mapRectThatFits(
                    route.polyline.boundingMapRect,
                    edgePadding: UIEdgeInsets(top: 64, left: 32, bottom: 500, right: 32)
                )
                self.parent.mkMapView.setRegion(MKCoordinateRegion(rect), animated: true)
            }
        }

        func showDriverAnnotations(_ drivers: [Driver]) {
            for driver in drivers where driverAnnotations[driver.id] == nil {
                let annotation = DriverAnnotation(driver: driver)
                driverAnnotations[driver.id] = annotation
                parent.mkMapView.addAnnotation(annotation)
            }
        }

        func clearMapViewAndRecenterOnUserLocation() {
            currentDestination = nil
            parent.mkMapView.removeAnnotations(parent.mkMapView.annotations.filter { !($0 is DriverAnnotation) })
            parent.mkMapView.removeOverlays(parent.mkMapView.overlays)

            if let currentRegion {
                parent.mkMapView.setRegion(currentRegion, animated: true)
            }
        }
    }
}
