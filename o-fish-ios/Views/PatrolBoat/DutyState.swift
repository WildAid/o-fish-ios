//
//  DutyState.swift
//
//  Created on 22/07/20.
//  Copyright © 2020 WildAid. All rights reserved.
//

import Foundation
import RealmSwift

class DutyState: ObservableObject {

    static let shared = DutyState()

    var user: UserViewModel? {
        didSet {
            if let user = user {
                self.dutyState = loadOnDutyState(user: user)
            }
        }
    }

    var onDuty: Bool {
        get {
            dutyState
        }
        set {
            recordOnDutyChange(status: newValue)
        }
    }

    @Published private var dutyState = false

    func recordOnDutyChange(status: Bool, date: Date = Date()) {
        dutyState = status

        let dutyChangeViewModel = DutyChangeViewModel()
        guard let user = user else {
            print("User not set when trying to record onDuty change")
            return
        }
        dutyChangeViewModel.date = date
        dutyChangeViewModel.user = user
        dutyChangeViewModel.status = status ? .onDuty : .offDuty
        if status {
            NotificationManager.shared.requestNotificationAfterStartDuty(hours: Constants.Notifications.hoursAfterStarting)
        } else {
            NotificationManager.shared.removeAllNotification()
        }
        dutyChangeViewModel.save()
    }

    private func loadOnDutyState(user: UserViewModel) -> Bool {
        let predicate = NSPredicate(format: "user.email = %@", user.email)

        guard let dutyChange = app.currentUser()?
                .agencyRealm()?
                .objects(DutyChange.self)
                .filter(predicate)
                .sorted(byKeyPath: "date", ascending: false)
                .first ?? nil else {
            return false
        }

        return DutyChangeViewModel(dutyChange: dutyChange).status == .onDuty ? true : false
    }
}
