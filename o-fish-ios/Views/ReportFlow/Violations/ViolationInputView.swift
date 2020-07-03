//
//  ViolationInputView.swift
//
//  Created on 3/12/20.
//  Copyright © 2020 WildAid. All rights reserved.
//

import SwiftUI

private enum PresentedSheet {
    case notPresented
    case chooseCrewMember
    case chooseViolation
}

struct ViolationInputView: View {
    @Binding var isViolationNonEmpty: Bool

    var report: ReportViewModel
    var crew: [CrewMemberViewModel]
    @ObservedObject var violation: ViolationViewModel
    let index: Int
    var removeClicked: ((ViolationViewModel) -> Void)?

    @State private var showingCrewMemberSheet = false
    @State private var showingViolationSheet = false

    private enum Dimensions {
        static let spacing: CGFloat = 16
    }

    var body: some View {
        VStack(spacing: Dimensions.spacing) {
            HStack {
                TitleLabel(title: NSLocalizedString("Violation", comment: "") + " \(index)")
                AddAttachmentsButton(attachments: violation.attachments)
            }
                .padding(.top, Dimensions.spacing)

            ButtonField(title: "Violation",
                        text: violation.fullViolationDescription,
                        fieldButtonClicked: {
                            self.showingViolationSheet = true
            })
                .fixedSize(horizontal: false, vertical: true)
                .sheet(isPresented: $showingViolationSheet) {
                    ChooseViolationsView(selectedItem:
                        Binding<ViolationPickerData>(
                            get: { .notSelected },
                            set: {
                                self.violation.offence.code = [$0.caption, $0.title].joined(separator: "\n")
                                self.violation.offence.explanation = $0.description
                                self.updateViolationStatus()
                        }
                        )
                    )
            }

            SegmentedField(selectedItem: Binding<String>(
                get: { self.violation.disposition.rawValue },
                set: {
                    self.violation.disposition = ViolationViewModel.Disposition(rawValue: $0) ?? .notSelected
                    self.updateViolationStatus()
            }),
                title: "Result of Violation",
                items: ViolationViewModel.Disposition.allValues.map { $0.rawValue })

            Group {
                if violation.crewMember.name.isEmpty && violation.crewMember.license.isEmpty {
                    ButtonField(title: "Issued to",
                                text: violation.crewMember.name,
                                fieldButtonClicked: chooseCrewMemberClicked)
                } else {
                    Button(action: chooseCrewMemberClicked) {
                        VStack(spacing: .zero) {
                            CaptionLabel(title: "Issued to")
                            CrewMemberShortView(crewMember: violation.crewMember, showingLicenseNumber: false)
                                .padding(.bottom, Dimensions.spacing)
                            Divider()
                        }
                    }
                }
            }
                .sheet(isPresented: $showingCrewMemberSheet) {
                    ViolationCrewMemberSelectView(report: self.report,
                                                  items: self.crew,
                                                  selectedItem:
                        Binding<CrewMemberViewModel>( get: { self.violation.crewMember },
                                                      set: {
                                                        self.violation.crewMember = CrewMemberViewModel($0)
                                                        self.updateViolationStatus()
                        })
                    )
                }

            AttachmentsView(attachments: violation.attachments)

            SectionButton(title: NSLocalizedString("Remove Violation", comment: "") + " \(index)",
                systemImageName: "minus",
                callingToAction: false,
                action: { self.removeClicked?(self.violation) })
                .padding(.bottom, Dimensions.spacing)
        }
    }

    private func updateViolationStatus() {
        isViolationNonEmpty = !violation.isEmpty
    }

    private func chooseCrewMemberClicked() {
        showingCrewMemberSheet = true
    }
}

struct ViolationItemInputView_Previews: PreviewProvider {
    static var previews: some View {
        let sampleCaptain = CrewMemberViewModel.sample
        sampleCaptain.isCaptain = true
        return ViolationInputView(isViolationNonEmpty: .constant(true),
                           report: .sample,
                           crew: [sampleCaptain, sampleCaptain],
                           violation: .sample, index: 1)
    }
}
