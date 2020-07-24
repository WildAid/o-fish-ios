//
//  PatrolBoatView.swift
//
//  Created on 3/20/20.
//  Copyright © 2020 WildAid. All rights reserved.
//

import SwiftUI

struct PatrolBoatView: View {

    @ObservedObject var user = UserViewModel()
    @ObservedObject var onDuty = DutyState.shared
    var isLoggedIn: Binding<Bool>

    @State private var location = LocationViewModel(LocationHelper.currentLocation)
    @State private var showingPreboardingView = false
    @State private var showingSearchView = false
    @State private var showingPatrolSummaryView = false
    @State private var resetLocation = {}

    @State private var dutyReports = [ReportViewModel]()
    @State private var startDuty = DutyChangeViewModel()
    @State private var plannedOffDutyTime = Date()

    @State private var showingAlertItem: AlertItem?
    @State private var profilePicture: PhotoViewModel?

    let photoQueryManager = PhotoQueryManager.shared

    private enum Dimensions {
        static let bottomPadding: CGFloat = 75
        static let topPadding: CGFloat = 14
        static let coordPadding: CGFloat = 58.0
        static let coordTopPadding: CGFloat = 14.0
        static let allCoordPadding: CGFloat = 48.0
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

                NavigationLink(destination:
                   PatrolSummaryView(dutyReports: dutyReports,
                       startDuty: startDuty,
                       onDuty: onDuty,
                       plannedOffDutyTime: plannedOffDutyTime),

                    isActive: self.$showingPatrolSummaryView) {
                    EmptyView()
                }
            }
                .edgesIgnoringSafeArea(.all)
                .navigationBarItems(
                    leading:
                        PatrolBoatUserView(name: user.name.fullName,
                            photo: profilePicture,
                            action: showLogoutModal),

                    trailing:
                        TextToggle(isOn: dutyBinding,
                            titleLabel: "",
                            onLabel: "On Duty",
                            offLabel: "Off Duty")
                )
                .navigationBarTitle(Text(""), displayMode: .inline)
                .navigationBarBackButtonHidden(true)
        }
            .showingAlert(alertItem: $showingAlertItem)
            .onAppear(perform: onAppear)
    }

    private var dutyBinding: Binding<Bool> {
        Binding<Bool>(
            get: { self.onDuty.onDuty },
            set: {
                if !$0 {
                    self.showOffDutyConfirmation()
                } else {
                    self.onDuty.onDuty = $0
                }
            })
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

    private func onAppear() {
        if isLoggedIn.wrappedValue && !RealmConnection.isConnected {
            print("Connecting to realm from patrol")
            RealmConnection.connect()
        }

        user.email = RealmConnection.emailAddress
        user.name.first = RealmConnection.firstName
        user.name.last = RealmConnection.lastName
        onDuty.user = user

        profilePicture = getPicture(documentId: RealmConnection.profilePictureDocumentId)
        location = LocationViewModel(LocationHelper.currentLocation)
    }

    private func goOnDutyAlertClicked() {
        self.onDuty.onDuty = true
    }

    private func logoutAlertClicked() {
        RealmConnection.logout()
        isLoggedIn.wrappedValue = false
        NotificationManager.shared.removeAllNotification()
    }

    private func showLogoutModal() {
        // TODO: for some reason this works only from action and not from viewModifier
        // TODO: review when viewModifier actions will be available
        let popoverId = UUID().uuidString

        func hidePopover() {
            PopoverManager.shared.hidePopover(id: popoverId)
        }

        PopoverManager.shared.showPopover(id: popoverId, withButton: false) {
            LogoutModalView(logout: {
                hidePopover()
                self.showLogoutAlert()
            },
                cancel: {
                    hidePopover()
                })
                .background(Color.blackWithOpacity)
                .onTapGesture {
                    hidePopover()
                }
        }
    }

    private func showOffDutyConfirmation() {
        let endDutyTime = Date()
        guard let startDuty = getDutyStartForCurrentUser(),
              startDuty.status == .onDuty else { return }

        self.startDuty = startDuty
        self.plannedOffDutyTime = endDutyTime
        dutyReports = dutyReportsForCurrentUser(startDutyTime: startDuty.date, endDutyTime: endDutyTime)
        showingPatrolSummaryView = true
    }

    /// Logic

    private func getPicture(documentId: String?) -> PhotoViewModel? {
        guard let documentId = documentId else { return nil }
        let photos = photoQueryManager.photoViewModels(imagesId: [documentId])
        return photos.first
    }

    private func getDutyStartForCurrentUser() -> DutyChangeViewModel? {
        let userEmail = RealmConnection.emailAddress
        let predicate = NSPredicate(format: "user.email = %@", userEmail)

        let realmDutyChanges = RealmConnection.realm?.objects(DutyChange.self).filter(predicate).sorted(byKeyPath: "date", ascending: false) ?? nil

        guard let dutyChanges = realmDutyChanges,
              let dutyChange = dutyChanges.first else { return nil }

        return DutyChangeViewModel(dutyChange: dutyChange)
    }

    private func dutyReportsForCurrentUser(startDutyTime: Date, endDutyTime: Date) -> [ReportViewModel] {
        let userEmail = RealmConnection.emailAddress

        let predicate = NSPredicate(format: "timestamp > %@ AND timestamp < %@ AND reportingOfficer.email = %@",
            startDutyTime as NSDate, endDutyTime as NSDate, userEmail)

        let realmReports = RealmConnection.realm?.objects(Report.self).filter(predicate).sorted(byKeyPath: "timestamp", ascending: false) ?? nil

        guard let reports = realmReports else { return [] }

        var dutyReports = [ReportViewModel]()
        for report in reports {
            dutyReports.append(ReportViewModel(report))
        }
        return dutyReports
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
