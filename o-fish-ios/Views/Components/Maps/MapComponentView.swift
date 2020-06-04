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
    var isLocationInputNeeded: Bool = true

    private enum Dimensions {
        static let trailingPadding: CGFloat = 16.0
    }

    var body: some View {
        VStack(spacing: Dimensions.trailingPadding) {
            ZStack {
                MapView(centerCoordinate: self.$location.location, location: self.$location.location, recenter: self.$childReCenter)
                LocationPointView()
            }

            if isLocationInputNeeded {
                HStack {
                    LocationCoordsView(location: self.$location.location)
                    Button(action: refreshLocation) {
                        Image(systemName: "arrow.right.circle")
                            .foregroundColor(.main)
                    }
                        .padding()
                }
                    .padding(.horizontal, Dimensions.trailingPadding)
            }
        }
            .onAppear {
                self.reset = {
                    self.resetLocation()
                }
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

}

struct MapComponentView_Previews: PreviewProvider {
    static var previews: some View {
        let location = LocationViewModel()
        return MapComponentView(location: .constant(location), reset: .constant {})
            .environmentObject(Settings.shared)
    }
}
