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
    private var options = CatchViewModel.UnitSpecification.allCases
    @Binding private var showingSpeciesWarning: Bool
    @Binding private var showingWeightWarning: Bool
    @Binding private var showingUnitWarning: Bool
    @Binding private var showingCountWarning: Bool
    @State private var showingSpeciesPicker = false

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
        _showingWeightWarning = .constant(showingWarningState.wrappedValue && catchModel.weight == 0)
        _showingUnitWarning = .constant(showingWarningState.wrappedValue && catchModel.unit == .notSelected)
        _showingCountWarning = .constant(showingWarningState.wrappedValue && catchModel.number == 0)
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
            HStack(spacing: Dimensions.offset) {
                InputField(title: "Weight",
                           text: weightBinding,
                           tag: 0,
                           showingWarning: self.showingWeightWarning,
                           keyboardType: .decimalPad)
                UnitPickerField(title: "Unit",
                                options: options,
                                unit: $catchModel.unit,
                                showingWarning: self.showingUnitWarning)
            }
            InputField(title: "Count",
                       text: countBinding,
                       tag: 1,
                       showingWarning: self.showingCountWarning,
                       keyboardType: .numberPad)
            AttachmentsView(attachments: catchModel.attachments)
            SectionButton(title: NSLocalizedString("Remove", comment: "") + " " +  buttonTitle,
                systemImageName: "minus",
                callingToAction: false,
                action: { self.removeClicked?(self.catchModel) })
                .padding(.bottom, Dimensions.spacing)
        }
    }

    private var weightBinding: Binding<String> {
        Binding<String>(
            get: { self.catchModel.weight != 0 ? self.catchModel.weight.cleanValue : "" },
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

    private var buttonTitle: String {
        catchModel.fish.isEmpty ? (NSLocalizedString("Catch", comment: "") + " \(self.index)")
                                : NSLocalizedString(catchModel.fish, comment: "Fish type")
    }

    private func checkAllInput() {
        isCatchNonEmpty = !catchModel.isEmpty
        showingSpeciesWarning = showingWarningState && catchModel.fish.isEmpty
        showingWeightWarning = showingWarningState && catchModel.weight == 0
        showingUnitWarning = showingWarningState && catchModel.unit == .notSelected
        showingCountWarning = showingWarningState && catchModel.number == 0
        informationComplete = catchModel.isComplete
    }
}

struct CatchInputView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
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
