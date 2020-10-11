//
//  DraftBoardingsView.swift
//  
//  Created on 9/22/20.
//  Copyright © 2020 WildAid. All rights reserved.
//

import SwiftUI

struct DraftBoardingsView: View {

    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var settings: Settings
    @State private var rootIsActive: Bool = false
    @State private var storedReports = [ReportViewModel]()
    @State private var state: States = .empty

    // (1/2) Binding workaround for view updating after appearing onscreen to show navigation bar
    //
    // Problem: after appering view on screen with slow-mode animation you could see jumped view to the top of screen.
    // This way navigation bar is hidden
    //
    // It seems as Swift UI bug. Similar cases are described here:
    // https://developer.apple.com/forums/thread/654471
    // https://stackoverflow.com/questions/58756846/swiftui-view-content-layout-unexpectedly-pop-jumps-on-appear
    // https://developer.apple.com/forums/thread/125800
    @State private var updatedViewAfterShowing = false
    // End of (1/2)

    private enum States {
        case loading, empty, loaded
    }

    private struct Dimensions {
        static let topPadding: CGFloat = 20.0
    }

    var body: some View {
        VStack {
            stateView()
            Spacer()
        }
        .navigationBarHidden(false)
        .onAppear(perform: loadReports)
        // (2/2) Binding workaround for view updating after appearing onscreen to show navigation bar
        .alert(isPresented: $updatedViewAfterShowing) {
            Alert(title: Text(""))
        }
        // End of (2/2)
        .navigationBarTitle(LocalizedStringKey("Draft Boardings"), displayMode: .inline)
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: Button(action: { self.presentationMode.wrappedValue.dismiss() }) {
            BackButton(label: "")
        })

    }

    private func stateView() -> AnyView {
        switch state {

        case .loaded:
            return AnyView(DraftBoardingLoadedStateView(storedReports: $storedReports,
                                                        rootIsActive: $rootIsActive))

        case .loading:
            return AnyView(ActivityIndicator(
                isAnimating: Binding<Bool>(
                    get: { self.state == .loading },
                    set: { _ in }
                ),
                style: .medium)
                .padding(.top, Dimensions.topPadding))

        case .empty:
            return AnyView(EmptyDraftView())
        }
    }

    private func loadReports() {
        storedReports.removeAll()
        state = .loading
        let predicate = NSPredicate(format: "draft == true && reportingOfficer.email == %@", settings.realmUser?.emailAddress ?? "")
        let realmReports = settings.realmUser?
            .agencyRealm()?
            .objects(Report.self)
            .filter(predicate)
            .sorted(byKeyPath: "timestamp", ascending: false) ?? nil

        if let realmReports = realmReports {
            for report in realmReports {
                storedReports.append(ReportViewModel(report))
            }
        }

        state = storedReports.isEmpty ? .empty : .loaded
    }
}

struct DraftBoardingsView_Previews: PreviewProvider {
    static var settings = Settings()
    static var previews: some View {
        NavigationView {
            DraftBoardingsView()
                .environmentObject(settings)
        }
    }
}
