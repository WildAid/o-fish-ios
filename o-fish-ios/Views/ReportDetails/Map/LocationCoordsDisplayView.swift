//
//  LocationCoordsDisplayView.swift
//
//  Created on 27/03/2020.
//  Copyright © 2020 WildAid. All rights reserved.
//

import SwiftUI

struct LocationCoordsDisplayView: View {
    var location: LocationViewModel

    var body: some View {
        VStack {
            HStack(alignment: .center) {
                LabeledText(label: "Latitude", text: "\(location.latitude.locationDegrees(.latitude))")
                LabeledText(label: "Longitude", text: "\(location.longitude.locationDegrees(.longitude))")
            }
        }
    }
}

struct LocationCoordsDisplayView_Previews: PreviewProvider {
    static var previews: some View {
        LocationCoordsDisplayView(location: .sample)
    }
}
