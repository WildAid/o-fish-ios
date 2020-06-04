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
    @Published var emsType: EMSType = .notSelected
    @Published var emsDescription = ""
    @Published var registryNumber = ""
    @Published var attachments = AttachmentsViewModel()

    enum EMSType: String {
        case notSelected = ""
        case ais = "Automatic identification System (AIS)"
        case viirs = "Visible Infrared Imaging Radiometer Suite (VIIRS)"
        case vms = "Vessel Monitoring System (VMS)"
        case other = "Other"

        static let allCases = [ais, viirs, vms, other]
    }

    var isEmpty: Bool {
        emsType == .notSelected && registryNumber.isEmpty
    }

    convenience init(_ eMS: EMS?) {
        self.init()
        if let eMS = eMS {
            self.eMS = eMS
            emsType = EMSType(rawValue: eMS.emsType) ?? .notSelected
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
        eMS.emsType = emsType.rawValue
        eMS.emsDescription = emsDescription
        eMS.registryNumber = registryNumber
        eMS.attachments = attachments.save()
        return eMS
    }
}
