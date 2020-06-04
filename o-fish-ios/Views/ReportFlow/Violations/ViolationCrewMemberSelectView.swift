//
//  ViolationCrewMemberSelectView.swift
//
//  Created on 29/04/20.
//  Copyright © 2020 WildAid. All rights reserved.
//

import SwiftUI

struct ViolationCrewMemberSelectView: View {
    let report: ReportViewModel
    let items: [CrewMemberViewModel]
    @Binding var selectedItem: CrewMemberViewModel

    @State var showingCreateCrewMember = false

    var body: some View {
        Group {
            if showingCreateCrewMember {
                ViolationCreateCrewMemberView(report: self.report,
                    selectedItem: self.$selectedItem)
            } else {
                ChooseCrewMemberView(report: self.report,
                    items: self.items,
                    selectedItem: self.$selectedItem,
                    showingCreateCrewMember: self.$showingCreateCrewMember
                )
            }
        }
    }
}

struct ViolationCrewMemberSelectView_Previews: PreviewProvider {
    static var previews: some View {
        ViolationCrewMemberSelectView(report: .sample, items: [.sample, .sample, .sample], selectedItem: .constant(.sample))
    }
}
