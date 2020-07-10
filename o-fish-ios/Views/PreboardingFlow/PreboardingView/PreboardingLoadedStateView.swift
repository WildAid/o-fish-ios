//
//  LoadedStateView.swift
//
//  Created on 5/18/20.
//  Copyright © 2020 WildAid. All rights reserved.
//

import SwiftUI

struct PreboardingLoadedStateView: View {
    @ObservedObject var onDuty: DutyState
    @Binding var storedReports: [ReportViewModel]
    @Binding var showingRecentBoardings: Bool

    @State private var showingReport: ReportViewModel = .sample
    @State private var showingLoadingVesselRecordsView = false

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
                        Button(action: { self.vesselItemClicked(item) }) {
                            VesselItemView(report: item)
                        }
                    }
                }
            }

            NavigationLink(destination: LoadingVesselRecordView(report: showingReport, onDuty: self.onDuty),
                isActive: $showingLoadingVesselRecordsView) {
                EmptyView()
            }
        }
    }

    /// Actions

    func vesselItemClicked(_ item: ReportViewModel) {
        showingLoadingVesselRecordsView = true
        showingReport = item
    }
}

struct PreboardingLoadedStateView_Previews: PreviewProvider {
    static var previews: some View {
        PreboardingLoadedStateView(
            onDuty: DutyState.shared,
            storedReports: .constant([.sample, .sample]),
            showingRecentBoardings: .constant(true))
    }
}
