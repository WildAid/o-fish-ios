//
//  AlertItem.swift
//
//  Created on 14/05/2020.
//  Copyright © 2020 WildAid. All rights reserved.
//

import SwiftUI

struct AlertItem: Identifiable {
    var id = UUID()
    var title: String
    var message: String?
    var primaryButton: Alert.Button?
    var secondaryButton: Alert.Button = .default(Text("Keep Editing"))
}

extension View {
    func showingAlert(alertItem: Binding<AlertItem?>) -> some View {
        alert(item: alertItem) { alertItem in
            if let primaryButton = alertItem.primaryButton {
                if let message = alertItem.message {
                    return Alert(title: Text(LocalizedStringKey(alertItem.title)),
                                 message: Text(LocalizedStringKey(message)),
                                 primaryButton: primaryButton,
                                 secondaryButton: alertItem.secondaryButton)
                }
                return Alert(title: Text(LocalizedStringKey(alertItem.title)),
                             primaryButton: primaryButton,
                             secondaryButton: alertItem.secondaryButton)
            } else {
                return Alert(title: Text(LocalizedStringKey(alertItem.title)), message: Text(""), dismissButton: alertItem.secondaryButton)
            }
        }
    }
}
