//
//  ActivityView.swift
//
//  Created on 3/5/20.
//  Copyright © 2020 WildAid. All rights reserved.
//

import SwiftUI

enum ActivityItem: String {
       case activity = "Activity"
       case fishery = "Fishery"
       case gear = "Gear"
}

struct ActivityView: View {

    @ObservedObject private var inspection: InspectionViewModel
    @Binding private var allFieldsComplete: Bool
    @Binding private var showingWarningState: Bool

    @Binding private var showingActivityWarning: Bool
    @Binding private var showingFisheryWarning: Bool
    @Binding private var showingGearWarning: Bool

    private let spacing: CGFloat = 16

    init(inspection: InspectionViewModel,
         allFieldsComplete: Binding<Bool>,
         showingWarningState: Binding<Bool>) {

        self.inspection = inspection

        _allFieldsComplete = allFieldsComplete
        _showingWarningState = showingWarningState

        _showingActivityWarning = .constant(showingWarningState.wrappedValue && inspection.activity.name.isEmpty)
        _showingFisheryWarning = .constant(showingWarningState.wrappedValue && inspection.fishery.name.isEmpty)
        _showingGearWarning = .constant(showingWarningState.wrappedValue && inspection.gearType.name.isEmpty)
    }

    var body: some View {
        KeyboardControllingScrollView {
            VStack(spacing: self.spacing) {

                ActivityItemView(attachments: self.inspection.activity.attachments,
                                 name: self.activityNameBinding,
                                 showingWarningState: self.showingActivityWarning,
                                 activityItem: .activity)

                ActivityItemView(attachments: self.inspection.fishery.attachments,
                                 name: self.fisheryNameBinding,
                                 showingWarningState: self.showingFisheryWarning,
                                 activityItem: .fishery)

                ActivityItemView(attachments: self.inspection.gearType.attachments,
                                 name: self.gearNameBinding,
                                 showingWarningState: self.showingGearWarning,
                                 activityItem: .gear)
            }
        }
    }

    /// logic

    private var activityNameBinding: Binding<String> {
        Binding<String>(
            get: { self.inspection.activity.name },
            set: {
                self.inspection.activity.name = $0
                self.checkAllInput()
        })
    }

    private var fisheryNameBinding: Binding<String> {
        Binding<String>(
            get: { self.inspection.fishery.name },
            set: {
                self.inspection.fishery.name = $0
                self.checkAllInput()
        })
    }

    private var gearNameBinding: Binding<String> {
        Binding<String>(
            get: { self.inspection.gearType.name },
            set: {
                self.inspection.gearType.name = $0
                self.checkAllInput()
        })
    }

    private func checkAllInput() {
        showingActivityWarning = showingWarningState && inspection.activity.name.isEmpty
        showingFisheryWarning = showingWarningState && inspection.fishery.name.isEmpty
        showingGearWarning = showingWarningState && inspection.gearType.name.isEmpty

        allFieldsComplete = !inspection.activity.name.isEmpty
            && !inspection.fishery.name.isEmpty
            && !inspection.gearType.name.isEmpty
    }
}

struct ActivityView_Previews: PreviewProvider {
    static var previews: some View {
        ActivityView(inspection: .sample,
            allFieldsComplete: .constant(false),
            showingWarningState: .constant(false))
    }
}
