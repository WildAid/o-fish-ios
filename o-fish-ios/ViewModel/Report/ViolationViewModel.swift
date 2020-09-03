//
//  ViolationViewModel.swift
//
//  Created on 14/03/2020.
//  Copyright © 2020 WildAid. All rights reserved.
//

import Foundation

class ViolationViewModel: ObservableObject, Identifiable {
    private var violation: Violation?

    @Published var id = UUID().uuidString
    @Published var disposition: Disposition = .notSelected
    @Published var offence = OffenceViewModel()
    @Published var crewMember = CrewMemberViewModel()
    @Published var attachments = AttachmentsViewModel()

    enum Disposition: String {
        case notSelected = ""
        case warning = "Warning"
        case citation = "Citation"

        static let allValues: [Disposition] = [.warning, .citation]
    }

    var fullViolationDescription: String {
        if self.offence.code.isEmpty && self.offence.explanation.isEmpty {
            return ""
        } else {
            return [NSLocalizedString(self.offence.code, comment: ""),
                     NSLocalizedString(self.offence.explanation, comment: "")].joined(separator: "\n")
        }
    }

    var isEmpty: Bool {
        disposition == .notSelected && offence.isEmpty && crewMember.isEmpty
    }

    convenience init(_ violation: Violation?) {
        self.init()
        if let violation = violation {
            self.violation = violation
            disposition = Disposition(rawValue: violation.disposition) ?? .notSelected
            offence = OffenceViewModel(violation.offence)
            crewMember = CrewMemberViewModel(violation.crewMember)
            attachments = AttachmentsViewModel(violation.attachments)
        } else {
            self.violation = Violation()
        }
    }

    func save() -> Violation? {
        if violation == nil {
            violation = Violation()
        }
        guard let violation = violation else { return nil }
        violation.disposition = disposition.rawValue
        violation.offence = offence.save()
        violation.crewMember = crewMember.save()
        violation.attachments = attachments.save()
        return violation
    }
}
