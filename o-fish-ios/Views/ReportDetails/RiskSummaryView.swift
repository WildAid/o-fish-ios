//
//  RiskSummaryView.swift
//  
//  Created on 9/3/20.
//  Copyright © 2020 WildAid. All rights reserved.
//

import SwiftUI

struct RiskSummaryView: View {
    @ObservedObject var risk: SafetyLevelViewModel

    private enum Dimensions {
        static let trailingPading: CGFloat = 50.0
        static let verticalPadding: CGFloat = 8.0
        static let spacing: CGFloat = 16.0
    }

    var body: some View {
        VStack(alignment: .center, spacing: Dimensions.spacing) {
            HStack {
                Text("Risk")
                    .font(Font.title3.weight(.semibold))
                Spacer()
                StatusSymbolView(risk: risk.level, size: .small)
            }

            if !titleReason.isEmpty && !risk.reason.isEmpty {
                HStack {
                    VStack(alignment: .leading) {
                        Text(titleReason)
                            .font(.caption1)
                            .foregroundColor(.removeAction)
                        Text("\(risk.reason)")
                            .font(.body)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    Spacer()
                }
            }

            if !risk.attachments.notes.isEmpty || !risk.attachments.photoIDs.isEmpty {
                AttachmentsView(attachments: risk.attachments, isEditable: false)
            } else {
                Text("No Notes or Photos for Risk")
                    .font(.body)
                    .foregroundColor(.captainGray)
                    .padding(.vertical, Dimensions.verticalPadding)
            }
        }
        .padding(.vertical, Dimensions.spacing)
    }

    private var titleReason: String {
        switch risk.level {
        case .green: return ""
        case .amber: return "Reason for Amber"
        case .red: return "Reason for Red"
        }
    }
}

struct RiskSummaryView_Previews: PreviewProvider {
    static var previews: some View {
        wrappedShadowView {
            RiskSummaryView(risk: .sample)
        }
    }
}
