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
    let backgroundOpacity = 0.1

    private enum Dimensions {
        static let spacing: CGFloat = 8
        static let captainLabelVerticalPadding: CGFloat = 3
        static let captainLabelHorizontalPadding: CGFloat = 10
        static let captainLabelRadius: CGFloat = 9.5
    }

    var body: some View {

        HStack(spacing: Dimensions.spacing) {
            VStack(spacing: Dimensions.spacing) {
                TextLabel(title: crewMember.name)
                CaptionLabel(title: crewMember.license, color: .text)
            }

            if crewMember.isCaptain {
                HStack {
                    Text("Captain".uppercased())
                        .font(.caption)
                        .foregroundColor(color)
                        .padding(.vertical, Dimensions.captainLabelVerticalPadding)
                        .padding(.horizontal, Dimensions.captainLabelHorizontalPadding)
                }

                    .background(color.opacity(backgroundOpacity))
                    .cornerRadius(Dimensions.captainLabelRadius)
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
            CrewMemberShortView(crewMember: sampleCaptain)
        }
    }
}
