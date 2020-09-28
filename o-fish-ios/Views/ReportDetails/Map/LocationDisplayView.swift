//
//  LocationDisplayView.swift
//
//  Created on 27/03/2020.
//

import SwiftUI
import MapKit

struct LocationDisplayView: View {
    @ObservedObject var report: ReportViewModel

    @State private var childReCenter: () -> Void = { }

    enum Dimensions {
        static let mapHeight: CGFloat = 210
        static let circleSize: CGFloat = 32
        static let middleCircleSize: CGFloat = 14.0
        static let innerCircleSize: CGFloat = 10.0
        static let circleOpacity = 0.5
        static let padding: CGFloat = 16.0
    }

    var body: some View {
        return VStack(spacing: Dimensions.padding) {
            ZStack {
                MapDisplayView(location: self.report.location)
                    .frame(height: Dimensions.mapHeight)
                LocationPointView()
            }
            LocationCoordsDisplayView(location: report.location)
                .padding(.horizontal, Dimensions.padding)
        }
    }
}

struct LocationDisplayView_Previews: PreviewProvider {
    static var previews: some View {
        LocationDisplayView(report: .sample)
            .environmentObject(Settings.shared)
    }
}
