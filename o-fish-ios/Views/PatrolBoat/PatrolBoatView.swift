//
//  PatrolBoatView.swift
//
//  Created on 3/20/20.
//  Copyright © 2020 WildAid. All rights reserved.
//

import SwiftUI

class DutyState: ObservableObject {

    var user: UserViewModel?

    @Published var onDuty = false {
        didSet {
            recordOnDutyChange()
        }
    }

    init() {
        user = nil
    }

    init(user: UserViewModel) {
        self.user = user
        self._onDuty = Published(initialValue: loadOnDutyState(with: user))
    }

    private func recordOnDutyChange() {
        let dutyChangeViewModel = DutyChangeViewModel()
        guard let user = user else {
            print("User not set when trying to record onDuty change")
            return
        }
        dutyChangeViewModel.user = user
        dutyChangeViewModel.status = onDuty ? .onDuty : .offDuty
        dutyChangeViewModel.save()
    }

    private func loadOnDutyState(with user: UserViewModel) -> Bool {
        let predicate = NSPredicate(format: "user.email CONTAINS %@", user.email)

        guard let dutyChange = RealmConnection.realm?.objects(DutyChange.self).filter(predicate)
                                   .sorted(byKeyPath: "date", ascending: false).first ?? nil else {

            return false
        }

        return DutyChangeViewModel(dutyChange: dutyChange).status == .onDuty ? true : false
    }
}

struct PatrolBoatView: View {

    @ObservedObject var user = UserViewModel()
    @ObservedObject var onDuty = DutyState()
    var isLoggedIn: Binding<Bool>
    @State private var location = LocationViewModel(LocationHelper.currentLocation)
    @State private var showingLogOut = false
    @State private var showingPreboardingView = false
    @State private var showingSearchView = false
    @State private var resetLocation = {}

    @State private var showingAlertItem: AlertItem?

    private enum Dimensions {
        static let bottomPadding: CGFloat = 75
        static let topPadding: CGFloat = 14
        static let coordPadding: CGFloat = 58.0
        static let coordTopPadding: CGFloat = 14.0
        static let allCoordPadding: CGFloat = 48.0
        static let imagePadding: CGFloat = 8.0
        static let lineLimit = 1
        static let trailingPadding: CGFloat = 16.0
        static let trailingCoordPadding: CGFloat = 12.0
    }

    var body: some View {
        VStack {
            SearchBarButton(title: "Find records", action: {
                self.showingSearchView.toggle()
            })
                .padding(.vertical, Dimensions.topPadding)

            ZStack(alignment: .bottom) {
                MapComponentView(location: self.$location,
                    reset: self.$resetLocation,
                    isLocationViewNeeded: false)
                VStack {
                    HStack {
                        CoordsBoxView(location: location)
                            .padding(.trailing, Dimensions.trailingCoordPadding)
                            .padding(.leading, Dimensions.coordPadding)

                        LocationButton(action: resetLocation)
                            .padding(.trailing, Dimensions.coordTopPadding)
                    }
                        .padding(.top, Dimensions.coordTopPadding)
                    Spacer()
                    BoardButtonView {
                        if self.onDuty.onDuty {
                            self.showingPreboardingView.toggle()
                        } else {
                            self.showGoOnDutyAlert()
                        }
                    }
                        .padding(.bottom, Dimensions.bottomPadding)
                        .padding(.horizontal, Dimensions.allCoordPadding)

                    NavigationLink(
                        destination: PreboardingView(viewType: .preboarding, onDuty: onDuty),
                        isActive: self.$showingPreboardingView) {
                        EmptyView()
                    }
                }

                NavigationLink(destination: PreboardingView(viewType: .searchRecords,
                    onDuty: onDuty),
                    isActive: self.$showingSearchView) {
                    EmptyView()
                }
            }
                .edgesIgnoringSafeArea(.all)
                .actionSheet(isPresented: $showingLogOut) {
                    ActionSheet(title: Text("Choose the action"),
                        message: nil,
                        buttons: [.destructive(Text("Log Out"), action: showLogoutAlert),
                                  .default(Text("Cancel"))])
                }
                .navigationBarItems(leading:
                    Button(action: { self.showingLogOut = true }, label: {
                        HStack {
                            PersonIconView()
                                .padding(.trailing, Dimensions.imagePadding)
                            Text(user.name.fullName)
                                .foregroundColor(.black)
                                .lineLimit(Dimensions.lineLimit)
                        }
                    }), trailing:
                    TextToggle(isOn: $onDuty.onDuty, titleLabel: "", onLabel: "On Duty", offLabel: "Off Duty")
                )
                .navigationBarTitle(Text(""), displayMode: .inline)
                .navigationBarBackButtonHidden(true)
        }
            .showingAlert(alertItem: $showingAlertItem)
            .onAppear {
                self.user.email = RealmConnection.emailAddress
                self.user.name.first = RealmConnection.firstName
                self.user.name.last = RealmConnection.lastName
                self.onDuty.user = self.user
                if self.isLoggedIn.wrappedValue && !RealmConnection.isConnected {
                    print("Connecting to realm from patrol")
                    RealmConnection.connect()
                }
            }
    }

    /// Alerts

    private func showLogoutAlert() {
        showingAlertItem = AlertItem(title: "You sure you want to logout?",
            message: "You can only log back in once you have cellular service or are connected to WIFI with internet",
            primaryButton: .default(Text("Yes"), action: logoutAlertClicked),
            secondaryButton: .cancel())
    }

    private func showGoOnDutyAlert() {
        showingAlertItem = AlertItem(title: "You're currently off duty",
            message: "Change status to \"On Duty\" ",
            primaryButton: .default(Text("Yes"), action: goOnDutyAlertClicked),
            secondaryButton: .cancel())
    }

    /// Actions

    private func goOnDutyAlertClicked() {
        self.onDuty.onDuty = true
    }

    private func logoutAlertClicked() {
        RealmConnection.logout()
        isLoggedIn.wrappedValue = false
    }
}

struct PatrolBoatView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            PatrolBoatView(isLoggedIn: .constant(true))
                .environmentObject(Settings.shared)
        }
    }
}
