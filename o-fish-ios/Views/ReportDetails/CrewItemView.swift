//
//  CrewItemView.swift
//
//  Created on 5/25/20.
//  Copyright © 2020 WildAid. All rights reserved.
//

import SwiftUI

struct CrewItemView: View {
    var crewMember: CrewMemberViewModel
    var titleLabelName = "Name"

    private enum Dimensions {
        static let spacing: CGFloat = 16.0
    }

    var body: some View {
        VStack(spacing: Dimensions.spacing) {
            HStack(alignment: .top, spacing: Dimensions.spacing) {
                LabeledText(label: titleLabelName, text: crewMember.name)
                LabeledText(label: "License Number", text: crewMember.license)
            }

            if !crewMember.attachments.notes.isEmpty || !crewMember.attachments.photoIDs.isEmpty {
                AttachmentsView(attachments: crewMember.attachments, isEditable: false)
            }
        }
    }
}

struct CrewItemView_Previews: PreviewProvider {
    static var previews: some View {
        CrewItemView(crewMember: .sample)
    }
}
