//
//  CrewMemberShortView.swift
//
//  Created on 20/04/20.
//  Copyright © 2020 WildAid. All rights reserved.
//

import SwiftUI

struct CrewMemberShortView: View {
    @ObservedObject var crewMember: CrewMemberViewModel

    var color = Color.main
    var showingLicenseNumber = true

    private enum Dimensions {
        static let captainLabelVerticalPadding: CGFloat = 3
        static let captainLabelHorizontalPadding: CGFloat = 10
        static let backgroundOpacity = 0.1
        static let padding: CGFloat = 16
    }

    var body: some View {

        HStack(alignment: .top) {
            VStack(spacing: .zero) {
                TextLabel(title: crewMember.name)
                if showingLicenseNumber {
                    CaptionLabel(title: "Licence Number \( crewMember.license)", color: .text, font: .footnote)
                }
            }

            if crewMember.isCaptain {
                HStack {
                    Text("Captain".uppercased())
                        .font(Font.caption1.weight(.semibold))
                        .foregroundColor(color)
                        .padding(.vertical, Dimensions.captainLabelVerticalPadding)
                        .padding(.horizontal, Dimensions.captainLabelHorizontalPadding)
                }
                    .background(color.opacity(Dimensions.backgroundOpacity))
                    .cornerRadius(.infinity)
                    .padding(.trailing, showingLicenseNumber ? Dimensions.padding : .zero)
            }
        }
    }
}

struct CrewMemberShortView_Previews: PreviewProvider {
    static var previews: some View {
        let sampleCaptain = CrewMemberViewModel.sample
        sampleCaptain.isCaptain = true
        return Group {
            CrewMemberShortView(crewMember: .sample)
            CrewMemberShortView(crewMember: sampleCaptain, showingLicenseNumber: false)
        }
    }
}
