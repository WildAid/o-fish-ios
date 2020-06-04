//
//  GearTypeViewModel.swift
//
//  Created on 08/04/2020.
//  Copyright © 2020 WildAid. All rights reserved.
//

import Foundation

class GearTypeViewModel: ObservableObject, Identifiable {
    private var gearType: GearType?

    @Published var id = UUID().uuidString
    @Published var name = ""
    @Published var attachments = AttachmentsViewModel()

    convenience init(_ gearType: GearType?) {
        self.init()
        if let gearType = gearType {
            self.gearType = gearType
            name = gearType.name
            attachments = AttachmentsViewModel(gearType.attachments)
        } else {
            self.gearType = GearType()
        }
    }

    func save() -> GearType? {
        if gearType == nil {
            gearType = GearType()
        }
        guard let gearType = gearType else { return nil }

        gearType.name = name
        gearType.attachments = attachments.save()
        return gearType
    }
}
