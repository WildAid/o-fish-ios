//
//  DeliveryInputView.swift
//
//  Created on 24/02/2020.
//  Copyright © 2020 WildAid. All rights reserved.
//

import SwiftUI

struct DeliveryInputView: View {
    @ObservedObject var delivery: DeliveryViewModel
    let reportId: String
    @Binding var activeEditableComponentId: String
    @Binding var informationComplete: Bool
    @Binding var showingWarningState: Bool

    @State private var showingBusinessPickerSheet = false
    @State private var isAutofillBusiness = true
    @Binding private var showingBusinessWarning: Bool
    @Binding private var showingLocationWarning: Bool
    @Binding private var showingDateWarning: Bool

    private enum Dimensions {
        static let spacing: CGFloat = 16
        static let noSpacing: CGFloat = 0.0
        static let bottomPadding: CGFloat = 24.0
    }

    init(delivery: DeliveryViewModel,
         reportId: String,
         activeEditableComponentId: Binding<String>,
         informationComplete: Binding<Bool>,
         showingWarningState: Binding<Bool>) {
        self.delivery = delivery
        self.reportId = reportId
        _activeEditableComponentId = activeEditableComponentId
        _informationComplete = informationComplete
        _showingWarningState = showingWarningState

        _showingBusinessWarning = .constant(showingWarningState.wrappedValue && delivery.business.isEmpty)
        _showingLocationWarning = .constant(showingWarningState.wrappedValue && delivery.location.isEmpty)
        _showingDateWarning = .constant(showingWarningState.wrappedValue && delivery.date == nil)
    }

    var body: some View {
        VStack(spacing: Dimensions.spacing) {
            HStack {
                TitleLabel(title: "Last Delivery")
                AddAttachmentsButton(
                    attachments: delivery.attachments,
                    reportId: reportId)
            }
            .padding(.top, Dimensions.spacing)
            ButtonField(title: "Date",
                text: deliveryDate,
                showingWarning: showingDateWarning,
                fieldButtonClicked: dateFieldClicked)

            if isAutofillBusiness {
                VStack {
                    ButtonField(title: "Business",
                        text: delivery.business,
                        showingWarning: showingBusinessWarning,
                        fieldButtonClicked: self.showBusinessPicker)

                    ButtonField(title: "Location",
                        text: delivery.location,
                        showingWarning: showingLocationWarning,
                        fieldButtonClicked: self.showBusinessPicker)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .sheet(isPresented: $showingBusinessPickerSheet) {
                    ChooseBusinessView(selectedItem:
                        Binding<BusinessPickerData>(
                            get: { .notSelected },
                            set: {
                                self.delivery.business = $0.business
                                self.delivery.location = $0.location
                                self.checkAllInput()
                            }
                            ),
                        isAutofillItem: self.$isAutofillBusiness)
                    }
            } else {
                InputField(title: "Business",
                           text: $delivery.business,
                           tag: 0,
                           becomeFirstResponder: true,
                           placeholder: "Business name",
                           showingWarning: showingBusinessWarning,
                           inputChanged: inputChanged,
                           autocorrectionType: .no)
                InputMultilineFieldCaption(title: "Location",
                                           text: $delivery.location,
                                           showingWarning: showingLocationWarning,
                                           inputChanged: inputChanged,
                                           autocorrectionType: .no)
            }
            AttachmentsView(attachments: delivery.attachments)
        }
        .padding(.bottom, Dimensions.bottomPadding)
        .onTapGesture {
            self.activeEditableComponentId = self.delivery.id
        }
    }

    private func inputChanged() {
        self.checkAllInput()
    }

    private func dateFieldClicked() {
        // TODO: for some reason this works only from action and not from viewModifier
        // TODO: review when viewModifier actions will be available
        let popoverId = UUID().uuidString
        activeEditableComponentId = self.delivery.id
        let datePickerSelectClicked = { (date: Date) in
            self.delivery.date = date
            self.checkAllInput()
            PopoverManager.shared.hidePopover(id: popoverId)
        }
        PopoverManager.shared.showPopover(id: popoverId, content: {
            DatePickerView(date: delivery.date ?? Date(),
                           finalDate: Date(),
                           mode: .dateAndTime,
                           completion: datePickerSelectClicked)
        }, withButton: false)
    }

    private func showBusinessPicker() {
        self.showingBusinessPickerSheet.toggle()
        self.activeEditableComponentId = self.delivery.id
    }

    private var deliveryDate: String {
        (delivery.date as Date?)?.fullDateTime() ?? ""
    }

    private func checkAllInput() {
        showingBusinessWarning = showingWarningState && delivery.business.isEmpty
        showingLocationWarning = showingWarningState && delivery.location.isEmpty
        showingDateWarning = showingWarningState && delivery.date == nil
        informationComplete = !delivery.business.isEmpty
            && !delivery.location.isEmpty
            && delivery.date != nil
    }
}

struct DeliveryInputView_Previews: PreviewProvider {
    static var previews: some View {
        DeliveryInputView(
            delivery: .sample,
            reportId: "TestId",
            activeEditableComponentId: .constant(""),
            informationComplete: .constant(false),
            showingWarningState: .constant(false))
    }
}
