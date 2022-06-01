//
//  ProfilePageView.swift
//  
//  Created on 9/9/20.
//  Copyright © 2020 WildAid. All rights reserved.
//

import SwiftUI

struct ProfilePageView: View {
    @ObservedObject var user: UserViewModel
    @ObservedObject var dutyState: DutyState
    @ObservedObject var userSettings = UserSettings.shared
    @State var profilePicture: PhotoViewModel?

    @Environment(\.presentationMode) var presentationMode

    @State private var dutyReports = [ReportViewModel]()
    @State private var startDuty = DutyChangeViewModel()
    @State private var plannedOffDutyTime = Date()
    @State private var showingPatrolSummaryView = false
    @State private var showingAlertItem: AlertItem?
    let settings = Settings.shared
    let photoQueryManager = PhotoQueryManager.shared

    private enum Dimensions {
        static let spacing: CGFloat = 32.0
        static let stackSpacing: CGFloat = 14.0
        static let leadingPadding: CGFloat = 20.0
        static let padding: CGFloat = 16.0
        static let lineWidth: CGFloat = 1.0
        static let radius: CGFloat = 50.0
    }

    var body: some View {
        ZStack {

            Color.oAltBackground
                .ignoresSafeArea(edges: .top)

            VStack(alignment: .center, spacing: Dimensions.spacing) {
                VStack(alignment: .leading) {
                    VStack(alignment: .leading, spacing: .zero) {
                        HStack(spacing: Dimensions.stackSpacing) {
                            PatrolBoatUserView(photo: profilePicture,
                                               onSea: $dutyState.onDuty,
                                               size: .large,
                                               action: changeProfilePhoto)
                            VStack(alignment: .leading, spacing: .zero) {
                                Text(user.name.fullName)
                                    .foregroundColor(.oFieldValue)

                                Text(user.email)
                                    .foregroundColor(.oFieldTitle)
                            }
                            .font(.body)
                        }
                    }
                    .padding(.all, Dimensions.padding)
                    Divider()
                        .background(Color.oDivider)
                        .frame(height: Dimensions.lineWidth)

                    Toggle(isOn: dutyBinding) {
                        Text(dutyState.onDuty ? "At Sea" : "Not At Sea")
                            .foregroundColor(.oFieldTitle)
                            .font(.callout)
                    }
                    .padding(.all, Dimensions.padding)

                    Divider()
                        .background(Color.oDivider)
                        .frame(height: Dimensions.lineWidth)

                    Toggle(isOn: $userSettings.forceDarkMode) {
                        Text("Dark Mode")
                            .foregroundColor(.oFieldTitle)
                            .font(.callout)
                    }
                    .padding(.all, Dimensions.padding)

                    Divider()
                        .background(Color.oDivider)
                        .frame(height: Dimensions.lineWidth)
                }
                .background(Color.oBackground)
                VStack {
                    Button(action: showLogoutAlert) {
                        Spacer()
                        Text("Log Out")
                            .font(.body)
                            .foregroundColor(.oAccent)
                        Spacer()
                    }
                    .padding(.vertical, Dimensions.stackSpacing)
                    .background(Color.clear)
                    .cornerRadius(Dimensions.radius)
                    .overlay(
                        RoundedRectangle(cornerRadius: .infinity)
                            .stroke(Color.oAccent,
                                    lineWidth: Dimensions.lineWidth)
                    )
                }
                .padding(.horizontal, Dimensions.padding)
                Spacer()

                NavigationLink(destination:
                                PatrolSummaryView(dutyReports: dutyReports,
                                                  startDuty: startDuty,
                                                  onDuty: dutyState,
                                                  plannedOffDutyTime: plannedOffDutyTime,
                                                  rootIsActive: .constant(false)),
                               isActive: $showingPatrolSummaryView) {
                    EmptyView()
                }
                               .isDetailLink(false)
            }
            .background(Color.oBackground)
            .edgesIgnoringSafeArea(.bottom)
            .navigationBarTitle("", displayMode: .inline)
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: Button(action: {
                self.presentationMode.wrappedValue.dismiss()
            }) {
                Text("Close")
                    .foregroundColor(.oAccent)
            })
            .showingAlert(alertItem: $showingAlertItem)
        }
    }

    private var dutyBinding: Binding<Bool> {
        Binding<Bool>(
            get: { self.dutyState.onDuty },
            set: {
                if !$0 {
                    self.showOffDutyConfirmation()
                } else {
                    self.dutyState.onDuty = $0
                }
            })
    }

    private func changeProfilePhoto() {
        showPhotoPickerTypeModal()
    }

    private func showLogoutAlert() {
        showingAlertItem = AlertItem(title: "Logout?",
                                     message: "All draft boardings will be deleted, and you will be marked 'Not at Sea'!",
                                     primaryButton: .destructive(Text("Log Out"), action: logoutAlertClicked),
                                     secondaryButton: .cancel())
    }

    private func logoutAlertClicked() {
        guard let user = settings.realmUser else {
            print("Attempting to logout when no user logged in")
            return
        }

        deleteDraftReports()

        user.logOut { _ in
            DispatchQueue.main.async {
                self.settings.realmUser = nil
            }
            NotificationManager.shared.removeAllNotification()
        }
    }

    private func deleteDraftReports() {
        guard let realm = app.currentUser?.agencyRealm() else {
            print("Can't access Realm to delete photo")
            return
        }

        let predicate = NSPredicate(format: "draft == true && reportingOfficer.email == %@", settings.realmUser?.emailAddress ?? "")
        do {
            try realm.write {
                realm.delete(realm.objects(Report.self).filter(predicate))
            }
        } catch {
            print("Couldn't delete draft Reports from Realm")
        }
    }

    private func showPhotoPickerTypeModal() {
        // TODO: for some reason this works only from action and not from viewModifier
        // TODO: review when viewModifier actions will be available
        guard settings.realmUser != nil else {
            print("realmUser not set")
            return
        }

        let popoverId = UUID().uuidString
        let hidePopover = {
            PopoverManager.shared.hidePopover(id: popoverId)
        }
        PopoverManager.shared.showPopover(id: popoverId, content: {
            ModalView(buttons: [
                ModalViewButton(title: "Camera", action: {
                    hidePopover()
                    self.showPhotoTaker(source: .camera)
                }),

                ModalViewButton(title: "Photo Library", action: {
                    hidePopover()
                    self.showPhotoTaker(source: .photoLibrary)
                })
            ],
            cancel: hidePopover)
        }, withButton: false)
    }

    private func showPhotoTaker(source: UIImagePickerController.SourceType) {
        var photo: PhotoViewModel
        if let profilePicture = profilePicture {
            photo = profilePicture
        } else {
            photo = PhotoViewModel()
            if let id = settings.realmUser?.profilePictureDocumentId {
                photo.id = id
            }
        }

        PhotoCaptureController.show(reportID: "", source: source, photoToEdit: photo) { controller, pictureId in

            self.profilePicture = self.getPicture(documentId: pictureId)
            controller.hide()
        }
    }

    private func getPicture(documentId: String?) -> PhotoViewModel? {
        guard let documentId = documentId else { return nil }
        let photos = photoQueryManager.photoViewModels(imagesId: [documentId])
        return photos.first
    }

    private func showOffDutyConfirmation() {
        let endDutyTime = Date()
        guard let startDuty = getDutyStartForCurrentUser(),
              startDuty.status == .onDuty else { return }

        self.startDuty = startDuty
        plannedOffDutyTime = endDutyTime
        dutyReports = dutyReportsForCurrentUser(startDutyTime: startDuty.date, endDutyTime: endDutyTime)
        showingPatrolSummaryView = true
    }

    private func getDutyStartForCurrentUser() -> DutyChangeViewModel? {
        guard let user = settings.realmUser else {
            print("Bad state")
            return nil
        }
        let userEmail = user.emailAddress
        let predicate = NSPredicate(format: "user.email = %@", userEmail)

        let realmDutyChanges = settings.realmUser?
            .agencyRealm()?
            .objects(DutyChange.self)
            .filter(predicate)
            .sorted(byKeyPath: "date", ascending: false) ?? nil

        guard let dutyChanges = realmDutyChanges,
              let dutyChange = dutyChanges.first else { return nil }

        return DutyChangeViewModel(dutyChange: dutyChange)
    }

    private func dutyReportsForCurrentUser(startDutyTime: Date, endDutyTime: Date) -> [ReportViewModel] {
        guard let user = settings.realmUser else {
            print("Bad state")
            return []
        }
        let userEmail = user.emailAddress

        let predicate = NSPredicate(format: "timestamp > %@ AND timestamp < %@ AND reportingOfficer.email = %@",
                                    startDutyTime as NSDate, endDutyTime as NSDate, userEmail)

        let realmReports = settings.realmUser?
            .agencyRealm()?
            .objects(Report.self)
            .filter(predicate)
            .sorted(byKeyPath: "timestamp", ascending: false) ?? nil

        guard let reports = realmReports else { return [] }

        var dutyReports = [ReportViewModel]()
        for report in reports {
            dutyReports.append(ReportViewModel(report))
        }
        return dutyReports
    }
}

struct ProfilePageView_Previews: PreviewProvider {
    static var previews: some View {
        let user = UserViewModel()
        user.email = "test@email.com"
        let name = NameViewModel()
        name.first = "John"
        name.last = "Doe"
        user.name = name

        return
            Group {
                NavigationView {
                    ProfilePageView(user: user,
                                    dutyState: DutyState())
                }
                NavigationView {
                    ProfilePageView(user: user,
                                    dutyState: .sample)
                }
            }
    }
}
