//
//  LocationCoordsView.swift
//
//  Created on 24/02/2020.
//  Copyright © 2020 WildAid. All rights reserved.
//

import SwiftUI
import CoreLocation

struct LocationCoordsView: View {
    @Binding var location: CLLocationCoordinate2D

    private enum Dimensions {
        static let spacing: CGFloat = 16.0
    }

    var body: some View {
        HStack(spacing: Dimensions.spacing) {
            LabeledDoubleInput(label: "Latitude", value: self.$location.latitude)
            LabeledDoubleInput(label: "Longitude", value: self.$location.longitude)
        }
    }
}

struct LocationCoordsView_Previews: PreviewProvider {
    static var previews: some View {
        let location = LocationViewModel()
        return LocationCoordsView(location: .constant(location.location))
    }
}
