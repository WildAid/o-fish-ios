//
//  CrewMemberStaticView.swift
//
//  Created on 30/04/20.
//  Copyright © 2020 WildAid. All rights reserved.
//

import SwiftUI

struct CrewMemberStaticView: View {

    @ObservedObject var crewMember: CrewMemberViewModel

    var index: Int = 0
    var isCaptain = false
    var isEditable = true

    var editClicked: ((CrewMemberViewModel) -> Void)?

    private enum Dimensions {
        static let spacing: CGFloat = 16.0
        static let bottomPadding: CGFloat = 24.0
    }

    var body: some View {
        VStack(spacing: Dimensions.spacing) {
            HStack {
                TitleLabel(title: isCaptain ? "Captain" : NSLocalizedString("Crew Member", comment: "") + " \(index)")

                if isEditable {
                    Button(action: { self.editClicked?(self.crewMember) }) {
                        EditIconView()
                    }
                }
            }
                .padding(.top, Dimensions.spacing)

            CrewItemView(crewMember: crewMember, titleLabelName: titleLabelName)
        }
            .padding(.bottom, Dimensions.bottomPadding)
    }

    private var titleLabelName: String {
        isCaptain ? "Captain's Name" : "Crew Member Name"
    }
}

struct CrewMemberStaticView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            CrewMemberStaticView(crewMember: .sample, isCaptain: true)
            Spacer()
            CrewMemberStaticView(crewMember: .sample, isCaptain: false)
        }
    }
}
