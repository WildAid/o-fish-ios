//
//  ActionSheetItem.swift
//  
//  Created on 9/21/20.
//  Copyright © 2020 WildAid. All rights reserved.
//

import SwiftUI

struct ActionSheetItem: Identifiable {
    var id = UUID()
    var title: String
    var message: String
    var firstButton: ActionSheet.Button = .default(Text(""))
    var secondButton: ActionSheet.Button = .default(Text("Keep Editing"))
    var thirdButton: ActionSheet.Button = .cancel()
}

extension View {

    func showingActionSheet(actionSheetItem: Binding<ActionSheetItem?>) -> some View {
        actionSheet(item: actionSheetItem) { actionSheetItem in
            return ActionSheet(title: Text(actionSheetItem.title), message: Text(actionSheetItem.message), buttons: [
                actionSheetItem.firstButton,
                actionSheetItem.secondButton,
                actionSheetItem.thirdButton
            ])
        }
    }
}
