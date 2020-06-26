//
//  ActivityItemView.swift
//
//  Created on 3/6/20.
//  Copyright © 2020 WildAid. All rights reserved.
//

import SwiftUI

extension ActivityItem {

    fileprivate struct SheetItem: Identifiable {
        var id = UUID()
        var title: String
        var searchBarPlaceholder: String
        var items: [String]
    }

    fileprivate func sheetItem() -> SheetItem {
        var items = [String]()

        switch self {
        case .activity:
            for activity in Settings.shared.menuData.activities {
                items.append(activity)
            }
            return SheetItem(title: self.rawValue,
                             searchBarPlaceholder: "Search Activities",
                             items: items)
        case .fishery:
            for fishery in Settings.shared.menuData.fisheries {
                items.append(fishery)
            }
            return SheetItem(title: self.rawValue,
                             searchBarPlaceholder: "Search Fisheries",
                             items: items)
        case .gear:
            for gear in Settings.shared.menuData.gear {
                items.append(gear)
            }
            return SheetItem(title: self.rawValue,
                             searchBarPlaceholder: "Search Gear",
                             items: items)
        }
    }
}

struct ActivityItemView: View {
    @ObservedObject var attachments: AttachmentsViewModel
    @Binding var name: String
    var showingWarningState: Bool
    var activityItem: ActivityItem

    @State private var showingSheetItem: ActivityItem.SheetItem?

    private enum Dimensions {
        static let bottomPadding: CGFloat = 24
        static let spacing: CGFloat = 16
    }

    var body: some View {
        VStack {
            wrappedShadowView {
                VStack(spacing: Dimensions.spacing) {
                    HStack {
                        TitleLabel(title: title)
                        AddAttachmentsButton(attachments: attachments)
                    }
                        .padding(.top, Dimensions.spacing)

                    ButtonField(title: buttonTitle,
                                text: name,
                                showingWarning: showingWarningState,
                                fieldButtonClicked: {
                                    self.showingSheetItem = self.activityItem.sheetItem()
                    })
                        .sheet(item: $showingSheetItem) { item in
                            TextPickerView(selectedItem: self.$name,
                                           items: item.items,
                                           title: item.title,
                                           searchBarPlaceholder: item.searchBarPlaceholder)
                    }
                    AttachmentsView(attachments: self.attachments)
                }
                    .padding(.bottom, Dimensions.bottomPadding)
            }
        }
    }

    private var title: String {
        activityItem.rawValue
    }

    private var buttonTitle: String {
        switch activityItem {

        case .activity, .fishery:
            return activityItem.rawValue

        case .gear:
            return "Gear Type"
        }
    }
}

struct ActivityItemView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            ActivityItemView(attachments: .sample,
                             name: .constant("Activity"),
                             showingWarningState: false,
                             activityItem: .activity)

            ActivityItemView(attachments: .sample,
                                        name: .constant(""),
                                        showingWarningState: true,
                                        activityItem: .fishery)

            ActivityItemView(attachments: .sample,
                             name: .constant("Gear Type"),
                             showingWarningState: false,
                             activityItem: .gear)
        }
    }
}
