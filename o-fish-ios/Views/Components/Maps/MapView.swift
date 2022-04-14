//
//  MapView.swift
//
//  Created on 24/02/2020.
//  Copyright © 2020 WildAid. All rights reserved.
//

import SwiftUI
import MapKit
import CoreLocation

struct MapView: UIViewRepresentable {
    @State var isEnable: Bool = true
    @Binding var centerCoordinate: CLLocationCoordinate2D
    @Binding var location: CLLocationCoordinate2D
    @Binding var recenter: () -> Void
    let settings = Settings.shared

    var locationManager = CLLocationManager()

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        let radius = CLLocationDistance(settings.intialZoomLevel)

        mapView.isUserInteractionEnabled = isEnable
        mapView.region = MKCoordinateRegion(center: centerCoordinate, latitudinalMeters: radius, longitudinalMeters: radius)
        mapView.delegate = context.coordinator
        return mapView
    }

    func updateUIView(_ mapView: MKMapView, context: Context) {
    }

    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: MapView

        init(_ parent: MapView) {
            self.parent = parent
        }

        func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
            parent.location = mapView.centerCoordinate
            parent.recenter = {
                print("centerCoordinate: \(self.parent.centerCoordinate.latitude), \(self.parent.centerCoordinate.longitude)")
                mapView.setCenter(self.parent.centerCoordinate, animated: true)
            }
        }
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView(centerCoordinate: .constant(LocationViewModel.sample.location),
                location: .constant(LocationViewModel.sample.location),
                recenter: .constant({}))
            .environmentObject(Settings.shared)
    }
}
