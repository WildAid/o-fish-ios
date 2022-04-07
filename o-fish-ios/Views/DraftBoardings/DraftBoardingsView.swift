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
    @State var rootIsActive: Bool = false
    @State private var storedReports = [ReportViewModel]()
    @State private var state: States = .empty
    @State private var showingDismissAlert = false

    private enum States {
        case loading, empty, loaded
    }

    private struct Dimensions {
        static let topPadding: CGFloat = 20.0
    }

    var body: some View {
        ZStack {
            Color.oAltBackground
                .edgesIgnoringSafeArea(.top)

            VStack {
                stateView()
                Spacer()
            }
            .frame(maxWidth: .infinity)
            .background(Color.oBackground)
            .navigationBarHidden(false)
            .onAppear(perform: loadReports)
            .navigationBarTitle("Draft Boardings", displayMode: .inline)
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: Button(action: { self.presentationMode.wrappedValue.dismiss() }) {
                BackButton(label: "")
            })
        }
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
