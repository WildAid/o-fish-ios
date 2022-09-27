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
    @Binding var mpaEnable: Bool
    @Binding var centerCoordinate: CLLocationCoordinate2D
    @Binding var location: CLLocationCoordinate2D
    @Binding var recenter: () -> Void
    @Binding var mpaSelected: MPA?
    @EnvironmentObject var settings: Settings
    var enableGesture = true
    let mapView = MKMapView()
    let locationManager = CLLocationManager()

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIView(context: Context) -> MKMapView {
        let radius = CLLocationDistance(settings.intialZoomLevel)
        mapView.isUserInteractionEnabled = isEnable
        mapView.region = MKCoordinateRegion(center: centerCoordinate, latitudinalMeters: radius, longitudinalMeters: radius)
        mapView.delegate = context.coordinator
        let tapGesture = UITapGestureRecognizer(target: context.coordinator, action: #selector(context.coordinator.handleTap(_:)))
        mapView.addGestureRecognizer(tapGesture)
        return mapView
    }

    func updateUIView(_ mapView: MKMapView, context: Context) {
        context.coordinator.mpa = settings.mpa
        if mpaEnable && !settings.mpa.isEmpty {
            guard mapView.overlays.isEmpty else { return }
            for mpa in settings.mpa {
                let coords = mpa.coordinates.map { CLLocationCoordinate2D(coord: $0) }
                let polygon = MKPolygon(coordinates: Array(coords), count: coords.count)
                polygon.title = mpa.name
                mapView.addOverlay(polygon)
            }
        } else {
            mapView.overlays.forEach { mapView.removeOverlay($0) }
            if mpaSelected != nil {
                mpaSelected = nil
            }
        }
    }

    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: MapView
        var mpa = [MPA]()

        init(_ parent: MapView) {
            self.parent = parent
        }

        @objc
        func handleTap(_ gesture: UITapGestureRecognizer) {
            guard !mpa.isEmpty && parent.enableGesture else { return }
            let mapView = parent.mapView
            let touch = gesture.location(in: mapView)
            let coordinate = parent.mapView.convert(touch, toCoordinateFrom: mapView)
            for overlay: MKOverlay in mapView.overlays {
                if let polygon = overlay as? MKPolygon {
                    let renderer = MKPolygonRenderer(polygon: polygon)
                    let mapPoint = MKMapPoint(coordinate)
                    let rendererPoint = renderer.point(for: mapPoint)
                    if renderer.path.contains(rendererPoint) {
                        guard let map = mpa.first(where: { $0.name == overlay.title }) else { continue }
                        parent.mpaSelected = map
                        print("Mpa Selected: \(map.name)")
                        return
                    } else {
                        parent.mpaSelected = nil
                        print("Mpa Selected: nil")
                    }
                }
            }
        }

        func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
            parent.location = mapView.centerCoordinate
            parent.recenter = {
                print("centerCoordinate: \(self.parent.centerCoordinate.latitude), \(self.parent.centerCoordinate.longitude)")
                mapView.setCenter(self.parent.centerCoordinate, animated: true)
            }
            guard !parent.enableGesture else { return }
            for overlay: MKOverlay in mapView.overlays {
                if let polygon = overlay as? MKPolygon {
                    let renderer = MKPolygonRenderer(polygon: polygon)
                    let mapPoint = MKMapPoint(mapView.centerCoordinate)
                    let rendererPoint = renderer.point(for: mapPoint)

                    if renderer.path.contains(rendererPoint),
                       let map = mpa.first(where: {$0.name == overlay.title}) {
                        parent.mpaSelected = map
                    } else {
                        parent.mpaSelected = nil
                    }
                }
            }
        }

        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            if let map = mpa.first(where: { $0.name == overlay.title }) {
                if overlay is MKPolygon {
                    let color = UIColor(hex: map.hexColor) ?? .purple
                    let polygonView = MKPolygonRenderer(overlay: overlay)
                    polygonView.strokeColor = color
                    polygonView.fillColor = color.withAlphaComponent(0.3)
                    return polygonView
                }
            }
            return MKOverlayRenderer()
        }

    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView(mpaEnable: .constant(true),
                centerCoordinate: .constant(LocationViewModel.sample.location),
                location: .constant(LocationViewModel.sample.location),
                recenter: .constant({}),
                mpaSelected: .constant(nil))
            .environmentObject(Settings.shared)
    }
}
