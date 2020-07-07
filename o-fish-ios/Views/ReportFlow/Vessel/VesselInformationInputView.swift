//
//  EMSInputView.swift
//
//  Created on 24/02/2020.
//  Copyright © 2020 WildAid. All rights reserved.
//

import SwiftUI

struct VesselInformationInputView: View {
    @ObservedObject var vessel: BoatViewModel
    let reportId: String
    @Binding var activeEditableComponentId: String
    @Binding var informationComplete: Bool
    @Binding var showingWarningState: Bool

    @State private var showingNationalityPicker = false

    @Binding private var showingNameWarning: Bool
    @Binding private var showingPermitNumberWarning: Bool
    @Binding private var showingHomePortWarning: Bool
    @Binding private var showingNationalityWarning: Bool

    private enum Dimensions {
        static let spacing: CGFloat = 16.0
        static let bottomPadding: CGFloat = 24.0
        static let noSpacing: CGFloat = 0.0
    }

    init(vessel: BoatViewModel,
         reportId: String,
         activeEditableComponentId: Binding<String>,
         informationComplete: Binding<Bool>,
         showingWarningState: Binding<Bool>) {

        self.vessel = vessel
        self.reportId = reportId
        _activeEditableComponentId = activeEditableComponentId
        _informationComplete = informationComplete
        _showingWarningState = showingWarningState

        _showingNameWarning = .constant(showingWarningState.wrappedValue && vessel.name.isEmpty)
        _showingPermitNumberWarning = .constant(showingWarningState.wrappedValue && vessel.permitNumber.isEmpty)
        _showingHomePortWarning = .constant(showingWarningState.wrappedValue && vessel.homePort.isEmpty)
        _showingNationalityWarning = .constant(showingWarningState.wrappedValue && vessel.nationality.isEmpty)
    }

    var body: some View {
        VStack(spacing: Dimensions.spacing) {
            HStack(alignment: .center) {
                TitleLabel(title: "Vessel Information")
                AddAttachmentsButton(attachments: vessel.attachments, reportId: reportId)
            }
                .padding(.top, Dimensions.spacing)

            InputField(title: "Vessel Name", text: $vessel.name,
                showingWarning: showingNameWarning,
                inputChanged: inputChanged)
            InputField(title: "Permit Number", text: $vessel.permitNumber,
                showingWarning: showingPermitNumberWarning,
                inputChanged: inputChanged)
            InputField(title: "Home Port", text: $vessel.homePort,
                showingWarning: showingHomePortWarning,
                inputChanged: inputChanged)

            Group {
                if hasNationality {
                    VStack(spacing: Dimensions.noSpacing) {
                        CaptionLabel(title: "Flag State")
                        Button(action: {
                            self.showingNationalityPicker.toggle()
                        }) {
                            CountryPickerDataView(item: displayedNationality)
                        }
                        Divider()
                    }
                } else {
                    ButtonField(title: "Flag State",
                                text: vessel.nationality,
                                showingWarning: showingNationalityWarning,
                                fieldButtonClicked: {
                                    self.showingNationalityPicker.toggle()
                    })
                }
            }
                .sheet(isPresented: $showingNationalityPicker) {
                    ChooseNationalityView(selectedItem:
                        Binding<CountryPickerData>(
                            get: { self.displayedNationality },
                            set: {
                                self.vessel.nationality = $0.title
                                self.checkAllInput()
                        }
                    ))
                }

                    AttachmentsView(attachments: vessel.attachments)
                }
                    .padding(.bottom, Dimensions.bottomPadding)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        self.activeEditableComponentId = self.vessel.id
                    }
    }

    /// Actions

    private func inputChanged(_ value: String) {
        self.checkAllInput()
    }

    /// Logic

    private var hasNationality: Bool {
        !vessel.nationality.isEmpty
    }

    private var displayedNationality: CountryPickerData {
        CountryPickerData(image: "\(transformCountryName(from: vessel.nationality))", title: vessel.nationality)
    }

    private func transformCountryName(from country: String) -> String {
        for code in Locale.isoRegionCodes as [String] {
            if let name = Locale.autoupdatingCurrent.localizedString(forRegionCode: code),
                name == country {
                return code
            }
        }
        return ""
    }

    private func checkAllInput() {
        showingNameWarning = showingWarningState && vessel.name.isEmpty
        showingPermitNumberWarning = showingWarningState && vessel.permitNumber.isEmpty
        showingHomePortWarning = showingWarningState && vessel.homePort.isEmpty
        showingNationalityWarning = showingWarningState && vessel.nationality.isEmpty

        informationComplete = !vessel.name.isEmpty
            && !vessel.permitNumber.isEmpty
            && !vessel.homePort.isEmpty
            && !vessel.nationality.isEmpty
    }
}

struct VesselInformationInputView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            VesselInformationInputView(
                vessel: .sample,
                reportId: "TestId",
                activeEditableComponentId: .constant(""),
                informationComplete: .constant(false),
                showingWarningState: .constant(false))
            .environment(\.locale, .init(identifier: "uk"))

            VesselInformationInputView(
                vessel: .sample,
                reportId: "TestId",
                activeEditableComponentId: .constant(""),
                informationComplete: .constant(false),
                showingWarningState: .constant(true))
        }
    }
}
