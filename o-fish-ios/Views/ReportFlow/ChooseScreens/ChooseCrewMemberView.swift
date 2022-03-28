//
//  ChooseCrewMemberView.swift
//
//  Created on 14/4/20.
//  Copyright © 2020 WildAid. All rights reserved.
//

import SwiftUI

extension CrewMemberViewModel: SearchableDataProtocol {
    var searchKey: String {
        self.name + self.license
    }

    private(set) static var notSelected = CrewMemberViewModel()
}

struct ChooseCrewMemberView: View {
    let report: ReportViewModel
    let items: [CrewMemberViewModel]
    @Binding var selectedItem: CrewMemberViewModel
    @Binding var showingCreateCrewMember: Bool

    @Environment(\.presentationMode) private var presentationMode

    @State private var searchText = ""

    private enum Dimensions {
        static let spacing: CGFloat = 16
        static let imageSize: CGFloat = 40
        static let cellSpacing: CGFloat = 8
    }

    var body: some View {
        VStack {
            HStack {
                ZStack {
                    Text("Crew")
                        .font(Font.callout.weight(.semibold))
                    HStack {
                        Button(action: dismiss) {
                            Text("Cancel")
                        }
                        Spacer()
                    }
                }
            }
            .padding([.top, .horizontal])

            SearchBarView(searchText: $searchText, placeholder: "Search Crew")

            ScrollView {
                VStack(spacing: .zero) {
                    ForEach(items.filter {
                        $0.isMatch(search: searchText) || searchText == ""
                    }) { item in

                        VStack(spacing: .zero) {
                            Button(action: { self.searchItemClicked(item: item) }) {
                                HStack(spacing: Dimensions.cellSpacing) {
                                    VStack {
                                        Image(systemName: "person.crop.circle.fill")
                                            .font(.system(size: Dimensions.imageSize))
                                            .foregroundColor(.removeAction)
                                    }
                                    CrewMemberShortView(crewMember: item)
                                }
                                .padding(.vertical, Dimensions.spacing)
                            }
                            Divider()
                        }
                    }

                    VStack(spacing: .zero) {
                        Button(action: { self.showingCreateCrewMember = true }) {
                            IconLabel(imagePath: "plus", title: "Add Crew Member", color: .oText, horizontalPadding: .zero)
                        }
                            .padding(.vertical, Dimensions.spacing)
                        Divider()
                    }

                    Spacer()
                }
                .padding(.horizontal, Dimensions.spacing)
            }
        }
    }

    private func dismiss() {
        presentationMode.wrappedValue.dismiss()
    }

    private func searchItemClicked(item: CrewMemberViewModel) {
        selectedItem = item
        dismiss()
    }
}

struct ChooseCrewMemberView_Previews: PreviewProvider {
    static var previews: some View {
        ChooseCrewMemberView(
            report: .sample,
            items: [.sample, .sample, .sample],
            selectedItem: .constant(.sample),
            showingCreateCrewMember: .constant(false))
    }
}
