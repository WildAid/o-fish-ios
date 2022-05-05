//
//  BasicInfoView.swift
//
//  Created on 04/03/2020.
//  Copyright © 2020 WildAid. All rights reserved.
//

import SwiftUI

struct BasicInfoView: View {

    @ObservedObject var report: ReportViewModel
    @Binding var allFieldsComplete: Bool
    @State private var resetLocation: () -> Void = {}
    var isNewBoarding: Bool

    private enum Dimensions {
        static let padding: CGFloat = 16.0
        static let bottomPadding: CGFloat = 24.0
        static let noSpacing: CGFloat = 0.0
        static let minHeight: CGFloat = 305.0
    }

    var body: some View {
        KeyboardControllingScrollView {
            VStack(spacing: Dimensions.padding) {
                wrappedShadowView {
                    VStack(spacing: Dimensions.padding) {
                        TitleLabel(title: "Date & Time")
                        DateTimeView(date: self.$report.date)
                    }
                        .padding(.top, Dimensions.padding)
                        .padding(.bottom, Dimensions.bottomPadding)
                }

                VStack(spacing: Dimensions.noSpacing) {
                    HStack {
                        TitleLabel(title: "Location")
                            .padding(.vertical, Dimensions.padding)
                        LocationButton(action: self.resetLocation,
                                           showingBackground: false)
                    }
                        .padding(.horizontal, Dimensions.padding)

                    MapComponentView(location: self.$report.location,
                                     reset: self.$resetLocation,
                                     isEnable: self.isNewBoarding)
                        .frame(minHeight: Dimensions.minHeight)
                        .padding(.bottom, Dimensions.bottomPadding)
                }
                    .background(Color.oSelectionBackground)
                    .compositingGroup()
                    .defaultShadow()
            }
        }
            .background(Color.oBackground)
            .onAppear(perform: { self.allFieldsComplete = true })
    }
}

struct BasicInfoView_Previews: PreviewProvider {
    static var previews: some View {
        let report = ReportViewModel()
        return BasicInfoView(report: report,
                             allFieldsComplete: .constant(false),
                             isNewBoarding: true)
            .environmentObject(Settings.shared)
    }
}
