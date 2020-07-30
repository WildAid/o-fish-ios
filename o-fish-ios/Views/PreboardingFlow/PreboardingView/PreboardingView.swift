//
//  PreboardingView.swift
//
//  Created on 3/23/20.
//  Copyright © 2020 WildAid. All rights reserved.
//

import SwiftUI
import RealmSwift

enum ViewType {
    case searchRecords
    case preboarding
}

struct PreboardingView: View {

    @Environment(\.presentationMode) var presentationMode

    var viewType: ViewType = .preboarding
    @ObservedObject var onDuty: DutyState

    @State private var searchText = ""
    @State private var showingDismissAlert = false
    @State private var storedReports = [ReportViewModel]()
    @State private var showingRecentBoardings = true
    @State private var state: States = .loading
    private let searchDebouncer = Debouncer(delay: 0.5, handler: {})
    private let countOfRecentReportsShown = 5

    private enum Dimension {
        static let topPadding: CGFloat = 20.0
        static let noSpacing: CGFloat = 0.0
        static let padding: CGFloat = 16.0
    }

    private enum States {
        case loading, empty, loaded
    }

    /// Interface

    var body: some View {
        VStack {
            searchBar

            if showingAddVessel {
                NavigationLink(destination: ReportNavigationRootView()) {
                    VStack(spacing: Dimension.noSpacing) {
                        IconLabel(imagePath: "plus", title: "Add New Vessel")
                            .padding(.vertical, Dimension.padding)
                        Divider()
                    }
                    Spacer()
                }
                    .opacity(state == .loading ? 0.0 : 1.0)
            }

            stateView()
            Spacer()
        }
            .onAppear(perform: loadRecentBoardings)
            .alert(isPresented: $showingDismissAlert) {
                Alert(title: Text("Cancel boarding?"),
                    message: Text("This boarding will not be saved"),
                    primaryButton: .default(Text("Go back")),
                    secondaryButton: .default(Text("Cancel")) {
                        self.presentationMode.wrappedValue.dismiss()
                    })
            }
            .navigationBarTitle(LocalizedStringKey(self.title), displayMode: .inline)
            .navigationBarItems(leading: Button(action: cancelTabBarClicked) {
                Text(LocalizedStringKey(backButtonTitle))
            })
            .navigationBarBackButtonHidden(true)
    }

    private var searchBar: some View {
        SearchBarView(
            searchText: Binding<String>(
                get: { self.searchText },
                set: {
                    self.searchText = $0
                    if !$0.isEmpty {
                        self.state = .loading
                        let debounceHandler: () -> Void = {
                            self.loadReports(with: self.searchText)
                        }
                        self.searchDebouncer.invalidate()
                        self.searchDebouncer.handler = debounceHandler
                        self.searchDebouncer.call()

                    } else {
                        self.storedReports = []
                        self.state = .loaded
                    }
                }),
            placeholder: searchbarPlaceholder
        )
    }

    private func stateView() -> AnyView {
        switch state {

        case .loaded:
            return AnyView(PreboardingLoadedStateView(
                onDuty: onDuty,
                storedReports: $storedReports,
                showingRecentBoardings: $showingRecentBoardings)
            )

        case .loading:
            return AnyView(ActivityIndicator(
                isAnimating: Binding<Bool>(
                    get: { self.state == .loading },
                    set: { _ in }
                ),
                style: .medium)
                .padding(.top, Dimension.topPadding))

        case .empty:
            return AnyView(EmptyStateView(searchWord: searchText))
        }
    }

    private var title: String {
        viewType == .searchRecords ? "Find Records" : "New Boarding"
    }

    private var searchbarPlaceholder: String {
        viewType == .searchRecords ? "Search" : "Search Vessels"
    }

    private var showingAddVessel: Bool {
        viewType == .searchRecords ? false : true
    }

    private var backButtonTitle: String {
        viewType == .searchRecords ? "Back" : "Cancel"
    }

    /// Actions

    private func cancelTabBarClicked() {
        if viewType == .preboarding {
            showingDismissAlert = true
            return
        }
        self.presentationMode.wrappedValue.dismiss()
    }

    private func loadReports(with searchText: String) {
        storedReports = []
        showingRecentBoardings = false
        let predicate = NSPredicate(format: "vessel.name CONTAINS[cd] %@", searchText)
        let realmReports = RealmConnection.realm?.objects(Report.self).filter(predicate).sorted(byKeyPath: "timestamp", ascending: false) ?? nil
        var uniqueIdentifiers = [String]()
        if let realmReports = realmReports {
            for report in realmReports {
                if let vessel = report.vessel {
                    if uniqueIdentifiers.filter({$0 == vessel.permitNumber }).isEmpty {
                        uniqueIdentifiers.append(vessel.permitNumber)
                        storedReports.append(ReportViewModel(report))
                    }
                }
            }
        }
        state = storedReports.isEmpty ? .empty : .loaded
    }

    private func loadRecentBoardings() {
        if storedReports.isEmpty {
            let realmReports = RealmConnection.realm?.objects(Report.self).sorted(byKeyPath: "timestamp", ascending: false) ?? nil
            var uniqueIdentifiers = [String]()
            if let realmReports = realmReports {
                for report in realmReports {
                    if let vessel = report.vessel {
                        if uniqueIdentifiers.filter({$0 == vessel.permitNumber || $0 == vessel.name }).isEmpty &&
                            !vessel.name.isEmpty {
                            uniqueIdentifiers.append(vessel.permitNumber.isEmpty ? vessel.name : vessel.permitNumber)
                            storedReports.append(ReportViewModel(report))
                            if storedReports.count > countOfRecentReportsShown - 1 {
                                self.state = .loaded
                                return
                            }
                        }
                    }
                }
            }
        }
        self.state = .loaded
    }
}

struct PreboardingView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            PreboardingView(viewType: .preboarding,
                            onDuty: .sample)
            Divider()
            PreboardingView(viewType: .searchRecords,
                            onDuty: .sample)
        }
    }
}
