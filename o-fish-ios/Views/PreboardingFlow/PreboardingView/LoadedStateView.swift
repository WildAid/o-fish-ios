//
//  LoadedStateView.swift
//
//  Created on 5/18/20.
//  Copyright © 2020 WildAid. All rights reserved.
//

import SwiftUI

struct LoadedStateView: View {
    @ObservedObject var onDuty: DutyState
    @Binding var storedReports: [ReportViewModel]
    @Binding var showingRecentBoardings: Bool

    private enum Dimensions {
        static let padding: CGFloat = 16.0
        static let paddingBottom: CGFloat = 8.0
        static let noSpacing: CGFloat = 0.0
    }

    var body: some View {
        VStack(spacing: Dimensions.noSpacing) {

            if showingRecentBoardings && !storedReports.isEmpty {
                HStack {
                    Text("Recently Boarded")
                        .font(Font.title3.weight(.semibold))
                    Spacer()
                }
                .padding([.top, .leading], Dimensions.padding)
                .padding(.bottom, Dimensions.paddingBottom)
            }

            ScrollView {
                VStack {
                    ForEach(storedReports) { item in
                        NavigationLink(destination: LoadingVesselRecordView(
                            report: item,
                            onDuty: self.onDuty)) { VesselItemView(report: item) }
                    }
                }
            }
        }
    }
}

struct LoadedStateView_Previews: PreviewProvider {
    static var previews: some View {
        LoadedStateView(
            onDuty: DutyState(user: UserViewModel()),
            storedReports: .constant([.sample, .sample]),
            showingRecentBoardings: .constant(true))
    }
}
