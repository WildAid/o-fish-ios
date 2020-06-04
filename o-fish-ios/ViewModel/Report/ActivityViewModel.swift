//
//  ActivityViewModel.swift
//
//  Created on 08/04/2020.
//  Copyright © 2020 WildAid. All rights reserved.
//

import Foundation

class ActivityViewModel: ObservableObject {
    private var activity: Activity?

    @Published var name = ""
    @Published var attachments = AttachmentsViewModel()

    convenience init(_ activity: Activity?) {
        self.init()
        if let activity = activity {
            self.activity = activity
            name = activity.name
            attachments = AttachmentsViewModel(activity.attachments)
        } else {
            self.activity = Activity()
        }
    }

    func save() -> Activity? {
        if activity == nil {
            activity = Activity()
        }
        guard let activity = activity else { return nil }

        activity.name = name
        activity.attachments = attachments.save()
        return activity
    }
}
