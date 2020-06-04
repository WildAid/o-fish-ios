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
    let index: Int
    var removeClicked: ((CatchViewModel) -> Void)?
    var attachClicked: ((CatchViewModel) -> Void)? // TODO fixme connect attaches

    /// Navigation states
    @State private var showingSpeciesPicker = false
    @State private var showingQunatityTypePicker = false
    @State private var showingUnitPicker = false

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
                AddAttachmentsButton(attachments: catchModel.attachments)
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
                        fieldButtonClicked: { self.showingUnitPicker = true })
                        .sheet(isPresented: self.$showingUnitPicker) {
                            UnitPickerWithButton(unit: self.$catchModel.unit,
                                                 selectButtonClicked: { self.showingUnitPicker = false })
                    }
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

    /// Internal logic
    private func updateCatchStatus() {
        isCatchNonEmpty = !catchModel.isEmpty
    }
}

struct CatchInputView_Previews: PreviewProvider {
    static var previews: some View {
        CatchInputView(isCatchNonEmpty: .constant(true), catchModel: .sample, index: 1)
    }
}
