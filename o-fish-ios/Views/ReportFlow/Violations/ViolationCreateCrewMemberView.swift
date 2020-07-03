//
//  ViolationCreateCrewMemberView.swift
//
//  Created on 27/04/20.
//  Copyright © 2020 WildAid. All rights reserved.
//

import SwiftUI

private enum PresentedAlert {
    case notPresented
    case replaceCaptain
    case emptyInput
}

struct ViolationCreateCrewMemberView: View {
    var report: ReportViewModel

    @Binding var selectedItem: CrewMemberViewModel

    @Environment(\.presentationMode) private var presentationMode

    @State private var name = ""
    @State private var license = ""
    @State private var isCaptain = true

    @State private var presentedAlert = PresentedAlert.notPresented

    @State private var attachments = AttachmentsViewModel()

    private enum Dimensions {
        static let spacing: CGFloat = 16
        static let bottomPadding: CGFloat = 24
    }

    var body: some View {
        VStack {
            wrappedShadowView {
                VStack(spacing: Dimensions.spacing) {
                    HStack {
                        TitleLabel(title: "Crew Member")
                        AddAttachmentsButton(attachments: attachments)
                    }
                        .padding(.vertical, Dimensions.spacing)

                    InputField(title: "Crew Member Name", text: $name)

                    InputField(title: "License Number", text: $license)

                    HStack {
                        Spacer()
                        CheckBox(title: "Captain", value: self.$isCaptain)
                    }

                    AttachmentsView(attachments: attachments)

                    CallToActionButton(title: "Add", action: addCrewMember)
                        .padding(.bottom, Dimensions.bottomPadding)
                }
            }

            Spacer()
        }
            .alert(isPresented:
                Binding<Bool>(
                    get: { self.presentedAlert != .notPresented },
                    set: {_ in self.presentedAlert = .notPresented}
                )
            ) {
                if self.presentedAlert == .replaceCaptain {
                    return Alert(title: Text("This report already contains captain"),
                        message: Text("Are you sure you want to replace captain?"),
                        primaryButton: .cancel(Text("Yes"), action: replaceCaptainClicked),
                        secondaryButton: .default(Text("Continue editing")))

                } else if self.presentedAlert == .emptyInput {
                    return Alert(title: Text("Empty fields"), message: Text("Please, input name or licence"))
                }

                assertionFailure("Should never reach this option")
                return Alert(title: Text(""))
            }
    }

    private func addCrewMember() {
        if name.isEmpty && license.isEmpty {
            presentedAlert = .emptyInput
            return
        }

        if isCaptain && !report.captain.isEmpty {
            presentedAlert = .replaceCaptain
            return
        }

        let crewMember = crewMemberFromInput()

        if isCaptain {
            if report.captain.isEmpty {
                report.captain = crewMember
            }
        } else {
            report.crew.append(crewMember)
        }

        dismiss(selected: crewMember)
    }

    private func replaceCaptainClicked() {
        let newCaptain = crewMemberFromInput()
        report.captain = newCaptain

        report.replaceCaptainInLinkedViolations(with: newCaptain)

        dismiss(selected: newCaptain)
    }

    /// Logic

    private func crewMemberFromInput() -> CrewMemberViewModel {
        let crewMember = CrewMemberViewModel()
        crewMember.name = name
        crewMember.license = license
        crewMember.isCaptain = isCaptain
        crewMember.attachments = attachments
        return crewMember
    }

    private func dismiss(selected: CrewMemberViewModel) {
        selectedItem = selected
        presentationMode.wrappedValue.dismiss()
    }
}

struct ViolationCreateCrewMemberView_Previews: PreviewProvider {
    static var previews: some View {
        ViolationCreateCrewMemberView(report: .sample, selectedItem: .constant(.sample))
    }
}
