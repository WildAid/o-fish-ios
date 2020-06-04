//
//  ReportListView.swift
//
//  Created on 25/02/2020.
//  Copyright © 2020 WildAid. All rights reserved.
//

import SwiftUI
import RealmSwift

class RefreshHack: ObservableObject {
    // TODO remove when Realm refreshes the view automatically
    @Published fileprivate var refreshToken = 0
}

struct ReportListView: View {
    @Environment(\.presentationMode) var presentationMode

    // TODO remove when Realm refreshes the view automatically
    @ObservedObject private var refreshHack = RefreshHack()

    @State private var storedReports: Results<Report>?
    @State private var creatingNewReport = true
    @State private var reportToEdit: ReportViewModel?
    @State private var pushedEditReportFlow = false
    @State private var errorMessage = ""
    @State private var loading = false

    private let horizontalPadding: CGFloat = 10.0

    var body: some View {
        GeometryReader { geo in
            ScrollView {
                VStack {
                    Text(self.errorMessage)
                        .foregroundColor(.red)

                    // Ideally would use `if let` here, but that isn't supported within a view and so
                    // we check that it's not `nil` and then unwrap it
                    if self.storedReports != nil {
                        ForEach(self.storedReports!) { report in
                            VStack {
                                Button(action: { self.reportItemClicked(item: ReportViewModel(report)) }) {
                                    ReportSummaryView(report: ReportViewModel(report))
                                }
                                Divider()
                            }
                            .padding([.horizontal, .top], self.horizontalPadding)
                        }
                    } else {
                        Text("Cannot access reports")
                    }
                    NavigationLink(destination: ReportNavigationRootView(report: self.reportToEdit),
                                   isActive: self.$pushedEditReportFlow) {
                        EmptyView()
                    }
                }
                    .frame(width: geo.size.width)
            }
        }
            .navigationBarItems(
                leading: Button(action: refresh) {
                    HStack {
                        Image(systemName: "arrow.down.doc")
                        Text("Refresh")
                    }
                },
                trailing: Button(action: newReportClicked) {
                    HStack {
                        Text("Add Report")
                        Image(systemName: "plus")
                    }
                }
            )
            .navigationBarTitle("Contact Reports", displayMode: .inline)
            .onAppear(perform: loadReports)
    }

    private func refresh() {
        refreshHack.refreshToken += 1
    }

    private func loadReports() {
        storedReports = RealmConnection.realm?.objects(Report.self).sorted(byKeyPath: "timestamp", ascending: false)
    }

    private func reportItemClicked(item: ReportViewModel) {
        creatingNewReport = false
        reportToEdit = item
        pushedEditReportFlow = true
    }

    private func newReportClicked() {
        creatingNewReport = true
        reportToEdit = nil
        pushedEditReportFlow = true
    }
}

struct ReportListView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ReportListView()
        }
    }
}
