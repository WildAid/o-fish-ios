//
//  MapComponentView.swift
//
//  Created on 24/02/2020.
//  Copyright © 2020 WildAid. All rights reserved.
//

import SwiftUI
import MapKit

struct MapComponentView: View {

    @Binding var location: LocationViewModel
    @Binding var reset: () -> Void
    @State private var childReCenter: () -> Void = { }
    @State private var alertIsPresented = false
    var isEnable: Bool = true
    var isLocationViewNeeded: Bool = true

    private enum Dimensions {
        static let trailingPadding: CGFloat = 16.0
    }

    var body: some View {
        VStack(spacing: Dimensions.trailingPadding) {
            ZStack {
                MapView(isEnable: isEnable,
                        centerCoordinate: self.$location.location,
                        location: self.$location.location,
                        recenter: self.$childReCenter)
                LocationPointView()
            }

            if isLocationViewNeeded {
                LocationCoordsView(location: self.$location.location)
                    .padding(.horizontal, Dimensions.trailingPadding)
                    .onTapGesture {
                        if isEnable {
                            alertIsPresented = true
                        }
                    }
            }
        }
        .onAppear {
            self.reset = {
                self.resetLocation()
            }
        }
        .textFieldAlert(isPresented: $alertIsPresented,
                        latitude: "\(location.latitude)",
                        longitude: "\(location.longitude)") { lat, lon in
            updateLocation(lat, lon)
        }
    }

    private func resetLocation() {
        print("Reseting location")
        location.location = LocationHelper.currentLocation
        childReCenter()
    }

    private func refreshLocation() {
        print("Refreshing location")
        print("Before: \(location.location.latitude), \(location.location.longitude)")
        childReCenter()
        print("After: \(location.location.latitude), \(location.location.longitude)")
    }

    private func updateLocation(_ lat: String, _ lon: String) {
        guard let lat = Double(lat),
              let lon = Double(lon) else {
            return
        }
        let latitude = min(max(lat, -90), 90)
        let longitude = min(max(lon, -180), 180)
        location.location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        childReCenter()
    }

}

struct MapComponentView_Previews: PreviewProvider {
    static var previews: some View {
        let location = LocationViewModel()
        return MapComponentView(location: .constant(location), reset: .constant {})
            .environmentObject(Settings.shared)
    }
}
