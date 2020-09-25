//
//  EMSViewModel.swift
//
//  Created on 14/03/2020.
//  Copyright © 2020 WildAid. All rights reserved.
//

import Foundation

class EMSViewModel: ObservableObject, Identifiable {
    private var eMS: EMS?

    @Published var id = UUID().uuidString
    @Published var emsType = ""
    @Published var emsDescription = ""
    @Published var registryNumber = ""
    @Published var attachments = AttachmentsViewModel()

    var isEmpty: Bool {
        emsType == "" && registryNumber.isEmpty
    }

    var isComplete: Bool {
        !emsType.isEmpty
            && !registryNumber.isEmpty
            && !(emsType == "Other" ? emsDescription.isEmpty : false)
    }

    convenience init(_ eMS: EMS?) {
        self.init()
        if let eMS = eMS {
            self.eMS = eMS
            emsType = eMS.emsType
            emsDescription = eMS.emsDescription
            registryNumber = eMS.registryNumber
            attachments = AttachmentsViewModel(eMS.attachments)
        } else {
            self.eMS = EMS()
        }
    }

    func save() -> EMS? {
        eMS = EMS()
        guard let eMS = eMS else { return nil }
        eMS.emsType = emsType
        eMS.emsDescription = emsDescription
        eMS.registryNumber = registryNumber
        eMS.attachments = attachments.save(clearModel: true)
        return eMS
    }
}
