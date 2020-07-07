//
//  RiskView.swift
//
//  Created on 05/03/2020.
//  Copyright © 2020 WildAid. All rights reserved.
//

import SwiftUI

struct RiskView: View {
    @ObservedObject var report: ReportViewModel
    @Binding var allFieldsComplete: Bool

    private enum Dimensions {
        static let bottomPadding: CGFloat = 24.0
        static let spacing: CGFloat = 16.0
        static let trafficLightPadding: CGFloat = 14.0
    }

    var body: some View {

        KeyboardControllingScrollView {
            wrappedShadowView {
                VStack(spacing: Dimensions.spacing) {
                    HStack {
                        TitleLabel(title: "Risk")
                        Spacer()
                        AddAttachmentsButton(attachments: self.report.inspection.attachments, reportId: self.report.id)
                    }
                        .padding(.top, Dimensions.spacing)

                    TrafficLights(color: self.$report.inspection.summary.safetyLevel.level)
                        .padding(.bottom, Dimensions.trafficLightPadding)
                    if self.report.inspection.summary.safetyLevel.level == .amber {
                        InputField(title: "Reason for amber", text: self.$report.inspection.summary.safetyLevel.amberReason)
                    }

                    AttachmentsView(attachments: self.report.inspection.attachments)
                }
                    .padding(.bottom, Dimensions.bottomPadding)
            }
        }
            .onAppear(perform: { self.allFieldsComplete = true })
    }
}

struct RiskView_Previews: PreviewProvider {
    static var previews: some View {
        RiskView(
            report: .sample,
            allFieldsComplete: .constant(false))
    }
}
