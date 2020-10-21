//
//  VesselSummaryView.swift
//
//  Created on 30/03/2020.
//  Copyright © 2020 WildAid. All rights reserved.
//

import SwiftUI

struct VesselSummaryView: View {

    @ObservedObject var vessel: BoatViewModel
    var isEditable = false
    var onClickEdit: (() -> Void)?

    private enum Dimensions {
        static let bottomPading: CGFloat = 24.0
        static let spacing: CGFloat = 16.0
    }

    var body: some View {
        VStack(spacing: Dimensions.spacing) {
            HStack(alignment: .center) {
                TitleLabel(title: "Vessel Information")
                if isEditable {
                    Button(action: onClickEdit ?? {}) {
                        EditIconView()
                    }
                    .foregroundColor(.secondary)
                }
            }
            .padding(.top, Dimensions.spacing)
            HStack(alignment: .top, spacing: Dimensions.spacing) {
                LabeledText(label: "Vessel Name", text: "\(vessel.name)")
                LabeledText(label: "Permit Number", text: "\(vessel.permitNumber)")
            }
            HStack(alignment: .top, spacing: Dimensions.spacing) {
                LabeledText(label: "Home Port", text: "\(vessel.homePort)")
                LabeledText(label: "Flag State", text: "\(getCountryName(from: vessel.nationality))")
            }
            AttachmentsView(attachments: vessel.attachments, isEditable: false)
        }
        .padding(.bottom, Dimensions.bottomPading)
    }

    private func getCountryName(from countryCode: String) -> String {
        return Locale.autoupdatingCurrent.localizedString(forRegionCode: countryCode) ?? ""
    }
}

struct VesselSummaryView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            VesselSummaryView(vessel: .sample, isEditable: true)
            VesselSummaryView(vessel: .sample, isEditable: false)
        }
    }
}
