//
//  CoordsBoxView.swift
//
//  Created on 02/04/2020.
//  Copyright © 2020 WildAid. All rights reserved.
//

import SwiftUI

struct CoordsBoxView: View {

    @ObservedObject var location: LocationViewModel

    private enum Dimensions {
        static let cornerRadius: CGFloat = 4.0
        static let padding: CGFloat = 8.0
        static let noSpacing: CGFloat = 0.0
    }

    var body: some View {
        HStack(spacing: Dimensions.noSpacing) {
            LabeledDoubleOutput(coordinate: .latitude, value: self.location.latitude)
            LabeledDoubleOutput(coordinate: .longitude, value: self.location.longitude)
        }
            .padding(.vertical, Dimensions.padding)
            .background(Color.oStrongOverlay)
            .cornerRadius(Dimensions.cornerRadius)
    }
}

struct CoordsBoxView_Previews: PreviewProvider {
    static var previews: some View {
        CoordsBoxView(location: LocationViewModel(LocationHelper.currentLocation))
            .environmentObject(Settings.shared)
            .background(Color.black)

    }
}
