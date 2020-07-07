//
//  CatchInputView.swift
//
//  Created on 02/03/2020.
//  Copyright © 2020 WildAid. All rights reserved.
//

import SwiftUI

struct CatchInputView: View {
    @Binding var isCatchNonEmpty: Bool
    @ObservedObject var catchModel: CatchViewModel
    let reportId: String
    let index: Int
    var removeClicked: ((CatchViewModel) -> Void)?

    /// Navigation states
    @State private var showingSpeciesPicker = false
    @State private var showingQunatityTypePicker = false

    private enum Dimensions {
        static let spacing: CGFloat = 16
        static let offset: CGFloat = 14
    }

    private var buttonTitle: String {
        catchModel.fish.isEmpty ? (NSLocalizedString("Catch", comment: "") + " \(self.index)")
                                : NSLocalizedString(catchModel.fish, comment: "Fish type")
    }

    var body: some View {
        VStack(spacing: Dimensions.spacing) {
            HStack {
                TitleLabel(title: NSLocalizedString("Catch", comment: "") + " \(self.index)")
                AddAttachmentsButton(attachments: catchModel.attachments, reportId: reportId)
            }
                .padding(.top, Dimensions.spacing)

            ButtonField(title: "Species", text: catchModel.fish,
                        fieldButtonClicked: { self.showingSpeciesPicker.toggle() })
                .sheet(isPresented: $showingSpeciesPicker) {
                    ChooseSpeciesView(selectedSpecies:
                        Binding<String>(
                            get: { self.catchModel.fish },
                            set: {
                                self.catchModel.fish = $0
                                self.updateCatchStatus()
                        })
                    )
            }

            ButtonField(title: "Amount",
                text: NSLocalizedString(catchModel.quantityTypeString, comment: "Amount type localized"),
                fieldButtonClicked: { self.showingQunatityTypePicker.toggle() })
                .sheet(isPresented: $showingQunatityTypePicker) {
                    ChooseQuantityTypeView(selectedItem:
                        Binding<[CatchViewModel.QuantityType]>(
                            get: { self.catchModel.quantityType },
                            set: {
                                self.catchModel.quantityType = $0
                                if !$0.contains(.count) {
                                    self.catchModel.number = 0
                                }
                                if !$0.contains(.weight) {
                                    self.catchModel.unit = .notSelected
                                    self.catchModel.weight = 0
                                }
                                self.updateCatchStatus()
                        })
                    )
            }

            if weightQuantitySelected {
                HStack(spacing: Dimensions.offset) {
                    InputField(title: "Weight",
                        text:
                        Binding<String>(
                            get: { self.catchModel.weight != 0 ? "\(self.catchModel.weight)" : "" },
                            set: {
                                let numberFormatter = NumberFormatter()
                                numberFormatter.maximumFractionDigits = 2
                                self.catchModel.weight = numberFormatter.number(from: $0)?.doubleValue ?? 0
                                self.updateCatchStatus()
                            })
                    )
                        .keyboardType(.numberPad)

                    ButtonField(title: "Unit",
                        text: NSLocalizedString(self.catchModel.unit.rawValue, comment: "Units localized"),
                        fieldButtonClicked: self.showUnitPickerClicked)
                }
            }

            if countQuantitySelected {
                InputField(title: "Count", text:
                    Binding<String>(get: { self.catchModel.number != 0 ? "\(self.catchModel.number)" : "" },
                        set: {
                            let numberFormatter = NumberFormatter()
                            self.catchModel.number = numberFormatter.number(from: $0)?.intValue ?? 0
                            self.updateCatchStatus()
                        })
                )
                    .keyboardType(.numberPad)
            }

            AttachmentsView(attachments: catchModel.attachments)

            SectionButton(title: NSLocalizedString("Remove", comment: "") + " " +  buttonTitle,
                systemImageName: "minus",
                callingToAction: false,
                action: { self.removeClicked?(self.catchModel) })
                .padding(.bottom, Dimensions.spacing)
        }
    }

    /// Interface data
    private var weightQuantitySelected: Bool {
        catchModel.quantityType.contains(.weight)
    }

    private var countQuantitySelected: Bool {
        catchModel.quantityType.contains(.count)
    }

    /// Actions

    private func showUnitPickerClicked() {
        // TODO: for some reason this works only from action and not from viewModifier
        // TODO: review when viewModifier actions will be available

        let popoverId = UUID().uuidString

        let unitPickerSelectClicked = { (unit: UnitPickerWithButton.UnitSpecification) in
            self.catchModel.unit = unit
            self.updateCatchStatus()
            PopoverManager.shared.hidePopover(id: popoverId)
        }

        PopoverManager.shared.showPopover(id: popoverId) {
            UnitPickerWithButton(selectButtonClicked: unitPickerSelectClicked)
                .background(Color.white)
        }
    }

    /// Internal logic
    private func updateCatchStatus() {
        isCatchNonEmpty = !catchModel.isEmpty
    }
}

struct CatchInputView_Previews: PreviewProvider {
    static var previews: some View {
        CatchInputView(isCatchNonEmpty: .constant(true), catchModel: .sample, reportId: "TestId", index: 1)
    }
}
