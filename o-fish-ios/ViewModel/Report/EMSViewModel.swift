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
        if eMS == nil {
            eMS = EMS()
        }
        guard let eMS = eMS else { return nil }
        eMS.emsType = emsType
        eMS.emsDescription = emsDescription
        eMS.registryNumber = registryNumber
        eMS.attachments = attachments.save()
        return eMS
    }
}
