//
//  DutyChangeViewModel.swift
//
//  Created on 25/03/2020.
//  Copyright © 2020 WildAid. All rights reserved.
//

import SwiftUI
import RealmSwift

class DutyChangeViewModel: ObservableObject {

    @Published var id = ObjectId.generate().stringValue
    @Published var user = UserViewModel()
    @Published var status: Status = .notSelected
    @Published var date: Date = Date()

    enum Status: String {
        case notSelected = ""
        case onDuty = "On Duty"
        case offDuty = "Off Duty"
    }

    private var dutyChange: DutyChange?

    convenience init(dutyChange: DutyChange) {
        self.init()

        self.dutyChange = dutyChange
        self.id = dutyChange._id.stringValue
        self.user = UserViewModel(dutyChange.user)
        self.status = Status(rawValue: dutyChange.status) ?? .notSelected
        self.date = dutyChange.date
    }

    func save() {
        let isNew = (dutyChange == nil)
        do {
            guard let realm = app.currentUser()?.agencyRealm() else {
                print("Realm not avaialable")
                return
            }
            try realm.write {
                if isNew {
                    dutyChange = DutyChange(id: id)
                }
                guard let dutyChange = dutyChange else { return }
                dutyChange.user = self.user.save()
                dutyChange.status = self.status.rawValue
                dutyChange.date = self.date
                if isNew {
                    realm.add(dutyChange)
                }
            }
        } catch {
            print("Couldn't add duty change to Realm")
        }
    }
}
