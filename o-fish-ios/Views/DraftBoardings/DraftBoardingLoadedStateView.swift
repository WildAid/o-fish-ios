//
//  DraftBoardingLoadedStateView.swift
//  
//  Created on 9/22/20.
//  Copyright © 2020 WildAid. All rights reserved.
//

import SwiftUI

struct DraftBoardingLoadedStateView: View {
    @Binding var storedReports: [ReportViewModel]
    @Binding var rootIsActive: Bool

    @State private var showingReport: ReportViewModel = ReportViewModel()

    let horizontalPadding: CGFloat = 16.0

    var body: some View {
        ScrollView {
            VStack {
                ForEach(storedReports) { item in
                    Button(action: { self.draftItemClicked(item) }) {
                        PatrolReportView(report: item)
                    }
                }
            }
                .padding(.horizontal, horizontalPadding)

            NavigationLink(destination: ReportNavigationRootView(report: showingReport,
                                                                 prefilledAvailable: false,
                                                                 isNewBoarding: false,
                                                                 rootIsActive: $rootIsActive),
                           isActive: $rootIsActive) {
                            EmptyView()
            }
                .isDetailLink(false)
        }
    }

    /// Actions

    func draftItemClicked(_ item: ReportViewModel) {
        rootIsActive.toggle()
        showingReport = item
    }
}

struct DraftBoardingLoadedStateView_Previews: PreviewProvider {
    static var previews: some View {
        DraftBoardingLoadedStateView(storedReports: .constant([.sample, .sample]),
                                     rootIsActive: .constant(true))
    }
}
