//
//  CatchView.swift
//
//  Created on 26/02/2020.
//  Copyright © 2020 WildAid. All rights reserved.
//

import SwiftUI

struct CatchView: View {
    @ObservedObject private var inspection: InspectionViewModel
    let reportId: String

    @State private var currentlyEditingCatchId: String
    @State private var showingAddCatchButton: Bool
    @State private var catchComplete: [String: Bool]

    @Binding private var allFieldsComplete: Bool
    @Binding private var showingWarningState: Bool

    private enum Dimensions {
        static let spacing: CGFloat = 16
        static let buttonTop: CGFloat = 8
        static let top: CGFloat = 24.0
    }

    init(inspection: InspectionViewModel,
         reportId: String,
         allFieldsComplete: Binding<Bool>,
         showingWarningState: Binding<Bool>) {

        _currentlyEditingCatchId = State(initialValue: inspection.actualCatch.last?.id ?? "")
        _showingAddCatchButton = State(initialValue: !(inspection.actualCatch.last?.isEmpty ?? true))

        _allFieldsComplete = allFieldsComplete
        _showingWarningState = showingWarningState

        _catchComplete = State(initialValue: [:])

        self.inspection = inspection
        self.reportId = reportId
    }

    var body: some View {
        KeyboardControllingScrollView {
            VStack(spacing: Dimensions.spacing) {
                ForEach(self.inspection.actualCatch.enumeratedArray(), id: \.element.id) { (index, catchModel) in
                    CatchOnBoardView(currentEditingCatchId: self.$currentlyEditingCatchId,
                        isCatchNonEmpty: self.$showingAddCatchButton,
                        informationComplete: self.informationCompleteBinding(catchModel),
                        showingWarningState: self.$showingWarningState,
                        catchModel: catchModel,
                        reportId: self.reportId,
                        index: index + 1,
                        removeClicked: self.removeFishOnBoardClicked
                    )
                }

                if self.inspection.actualCatch.isEmpty || self.showingAddCatchButton {
                    SectionButton(title: "Add Catch",
                        systemImageName: "plus",
                        action: { self.addNewCatch() })
                        .padding(.top, self.inspection.actualCatch.count > 0 ? Dimensions.buttonTop : Dimensions.top)
                        .padding(.bottom, Dimensions.buttonTop + Dimensions.spacing)
                }

                // TODO: Should be revisited after the June 2020 SwiftUI improvements
                HStack {
                    Spacer()
                }
                Spacer()
            }
        }
            .onAppear(perform: onAppear)
    }

    private func informationCompleteBinding(_ catchModel: CatchViewModel) -> Binding<Bool> {
        Binding<Bool>(
            get: { self.catchComplete[catchModel.id] ?? false },
            set: {
                self.catchComplete[catchModel.id] = $0
                self.checkAllInput()
            }
        )
    }

    /// Actions

    private func onAppear() {
        allFieldsComplete = true

        if inspection.actualCatch.isEmpty {
            addNewCatch()
        }
    }

    private func removeFishOnBoardClicked(_ catchViewModel: CatchViewModel) {
        inspection.actualCatch.removeAll { $0.id == catchViewModel.id }
        updateEditingCatch()
        catchComplete.removeValue(forKey: catchViewModel.id)
    }

    private func addNewCatch() {
        let catchModel = CatchViewModel()
        inspection.actualCatch.append(catchModel)
        catchComplete[catchModel.id] = false
        updateEditingCatch()
    }

    /// Logic

    private func updateEditingCatch() {
        currentlyEditingCatchId = inspection.actualCatch.last?.id ?? ""
        showingAddCatchButton = !(inspection.actualCatch.last?.isEmpty ?? true)
        checkAllInput()
    }

    private func checkAllInput() {
        allFieldsComplete = catchComplete.values.filter { $0 == false }.isEmpty
    }
}

struct CatchView_Previews: PreviewProvider {
    static var previews: some View {
        CatchView(
            inspection: .sample,
            reportId: "TestId",
            allFieldsComplete: .constant(false), showingWarningState: .constant(false))
    }
}
