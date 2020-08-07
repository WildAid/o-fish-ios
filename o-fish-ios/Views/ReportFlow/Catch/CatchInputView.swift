//
//  CatchInputView.swift
//
//  Created on 02/03/2020.
//  Copyright © 2020 WildAid. All rights reserved.
//

import SwiftUI

struct CatchInputView: View {
    @Binding private var isCatchNonEmpty: Bool
    @Binding private var informationComplete: Bool
    @Binding private var showingWarningState: Bool
    @ObservedObject private var catchModel: CatchViewModel
    private let reportId: String
    private let index: Int
    private var removeClicked: ((CatchViewModel) -> Void)?

    /// Warning state
    @Binding private var showingSpeciesWarning: Bool
    @Binding private var showingAmountWarning: Bool
    @Binding private var showingWeightWarning: Bool
    @Binding private var showingUnitWarning: Bool
    @Binding private var showingCountWarning: Bool

    /// Navigation states
    @State private var showingSpeciesPicker = false
    @State private var showingQunatityTypePicker = false

    private enum Dimensions {
        static let spacing: CGFloat = 16
        static let offset: CGFloat = 14
    }

    init(isCatchNonEmpty: Binding<Bool>,
         informationComplete: Binding<Bool>,
         showingWarningState: Binding<Bool>,
         catchModel: CatchViewModel,
         reportId: String,
         index: Int,
         removeClicked: ((CatchViewModel) -> Void)? = nil) {

        _isCatchNonEmpty = isCatchNonEmpty
        _informationComplete = informationComplete
        _showingWarningState = showingWarningState
        self.catchModel = catchModel
        self.reportId = reportId
        self.index = index
        self.removeClicked = removeClicked

        _showingSpeciesWarning = .constant(showingWarningState.wrappedValue && catchModel.fish.isEmpty)
        _showingAmountWarning = .constant(showingWarningState.wrappedValue && catchModel.quantityType == [.notSelected])

        _showingWeightWarning = .constant(showingWarningState.wrappedValue
            && catchModel.quantityType.contains(.weight) && catchModel.weight == 0)
        _showingUnitWarning = .constant(showingWarningState.wrappedValue
            && catchModel.quantityType.contains(.weight) && catchModel.unit == .notSelected)

        _showingCountWarning = .constant(showingWarningState.wrappedValue
            && catchModel.quantityType.contains(.count) && catchModel.number == 0)
    }

    var body: some View {
        VStack(spacing: Dimensions.spacing) {
            HStack {
                TitleLabel(title: NSLocalizedString("Catch", comment: "") + " \(self.index)")
                AddAttachmentsButton(attachments: catchModel.attachments, reportId: reportId)
            }
                .padding(.top, Dimensions.spacing)

            ButtonField(title: "Species", text: catchModel.fish,
                showingWarning: self.showingSpeciesWarning,
                fieldButtonClicked: { self.showingSpeciesPicker.toggle() })
                .sheet(isPresented: $showingSpeciesPicker) {
                    ChooseSpeciesView(selectedSpecies: self.selectedSpeciesBinding)
            }

            ButtonField(title: "Amount",
                text: NSLocalizedString(catchModel.quantityTypeString, comment: "Amount type localized"),
                showingWarning: self.showingAmountWarning,
                fieldButtonClicked: { self.showingQunatityTypePicker.toggle() })
                .sheet(isPresented: $showingQunatityTypePicker) {
                    ChooseQuantityTypeView(selectedItem: self.selectedQuantityTypeBinding)
            }

            if weightQuantitySelected {
                HStack(spacing: Dimensions.offset) {
                    InputField(title: "Weight", text: weightBinding,
                        showingWarning: self.showingWeightWarning)
                        .keyboardType(.numberPad)

                    ButtonField(title: "Unit",
                        text: NSLocalizedString(self.catchModel.unit.rawValue, comment: "Units localized"),
                        showingWarning: self.showingUnitWarning,
                        fieldButtonClicked: self.showUnitPickerClicked)
                }
            }

            if countQuantitySelected {
                InputField(title: "Count",
                    text: countBinding,
                    showingWarning: self.showingCountWarning)
                    .keyboardType(.numberPad)
            }

            if !catchModel.attachments.photoIDs.isEmpty || !catchModel.attachments.notes.isEmpty {
                AttachmentsView(attachments: catchModel.attachments)
            }

            SectionButton(title: NSLocalizedString("Remove", comment: "") + " " +  buttonTitle,
                systemImageName: "minus",
                callingToAction: false,
                action: { self.removeClicked?(self.catchModel) })
                .padding(.bottom, Dimensions.spacing)
        }
    }

    /// Bindings

    private var weightBinding: Binding<String> {
        Binding<String>(
            get: { self.catchModel.weight != 0 ? "\(self.catchModel.weight)" : "" },
            set: {
                let numberFormatter = NumberFormatter()
                numberFormatter.maximumFractionDigits = 2
                self.catchModel.weight = numberFormatter.number(from: $0)?.doubleValue ?? 0
                self.checkAllInput()
            })
    }

    private var countBinding: Binding<String> {
        Binding<String>(get: { self.catchModel.number != 0 ? "\(self.catchModel.number)" : "" },
            set: {
                let numberFormatter = NumberFormatter()
                self.catchModel.number = numberFormatter.number(from: $0)?.intValue ?? 0
                self.checkAllInput()
            })
    }

    private var selectedSpeciesBinding: Binding<String> {
        Binding<String>(
            get: { self.catchModel.fish },
            set: {
                self.catchModel.fish = $0
                self.checkAllInput()
            })
    }

    private var selectedQuantityTypeBinding: Binding<[CatchViewModel.QuantityType]> {
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
                self.checkAllInput()
            })
    }

    /// Interface data

    private var buttonTitle: String {
        catchModel.fish.isEmpty ? (NSLocalizedString("Catch", comment: "") + " \(self.index)")
                                : NSLocalizedString(catchModel.fish, comment: "Fish type")
    }

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
            self.checkAllInput()
            PopoverManager.shared.hidePopover(id: popoverId)
        }

        PopoverManager.shared.showPopover(id: popoverId) {
            UnitPickerWithButton(selectButtonClicked: unitPickerSelectClicked)
                .background(Color.white)
        }
    }

    /// Logic

    private func checkAllInput() {
        isCatchNonEmpty = !catchModel.isEmpty

        showingSpeciesWarning = showingWarningState && catchModel.fish.isEmpty
        showingAmountWarning = showingWarningState && catchModel.quantityType == [.notSelected]

        showingWeightWarning = showingWarningState
            && catchModel.quantityType.contains(.weight) && catchModel.weight == 0
        showingUnitWarning = showingWarningState
            && catchModel.quantityType.contains(.weight) && catchModel.unit == .notSelected

        showingCountWarning = showingWarningState
            && catchModel.quantityType.contains(.count) && catchModel.number == 0

        informationComplete = catchModel.isComplete
    }
}

struct CatchInputView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            CatchInputView(isCatchNonEmpty: .constant(true),
                informationComplete: .constant(true),
                showingWarningState: .constant(false),
                catchModel: .sample, reportId: "TestId", index: 1)

            CatchInputView(isCatchNonEmpty: .constant(true),
                informationComplete: .constant(false),
                showingWarningState: .constant(true),
                catchModel: .sample, reportId: "TestId", index: 1)
        }
    }
}
