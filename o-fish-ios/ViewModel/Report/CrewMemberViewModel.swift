//
//  CrewMemberViewModel.swift
//
//  Created on 14/03/2020.
//  Copyright © 2020 WildAid. All rights reserved.
//

import Foundation

class CrewMemberViewModel: ObservableObject, Identifiable {
    private var crewMember: CrewMember?

    @Published var id = UUID().uuidString
    @Published var name = ""
    @Published var license = ""
    @Published var attachments = AttachmentsViewModel()

    // TODO: Possible schema change will works better
    @Published var isCaptain = false

    var isEmpty: Bool {
        // TODO: Add attachment and photos isEmpty check
        name.isEmpty && license.isEmpty
    }

    var isComplete: Bool {
        !name.isEmpty && !license.isEmpty
    }

    convenience init(_ crewMember: CrewMember?, isCaptain: Bool = false) {
        self.init()
        if let crewMember = crewMember {
            self.crewMember = crewMember
            name = crewMember.name
            license = crewMember.license
            attachments = AttachmentsViewModel(crewMember.attachments)
        } else {
            self.crewMember = CrewMember()
        }

        self.isCaptain = isCaptain
    }

    convenience init(_ crewMember: CrewMemberViewModel) {
        self.init()
        name = crewMember.name
        license = crewMember.license
        isCaptain = crewMember.isCaptain
    }

    func save() -> CrewMember? {
        if  crewMember == nil {
            crewMember = CrewMember()
        }
        guard let crewMember = crewMember else { return nil }
        crewMember.name = name
        crewMember.license = license
        crewMember.attachments = attachments.save()
        return crewMember
    }
}
