//
//  TextFieldAlertModifier.swift
//  
//  Created on 14.04.2022.
//  Copyright © 2022 WildAid. All rights reserved.
//

import SwiftUI

public struct TextFieldAlertModifier: ViewModifier {

    @State private var alertController: UIAlertController?

    @Binding var isPresented: Bool

    let latitude: String
    let longitude: String
    let action: (String, String) -> Void

    public func body(content: Content) -> some View {
        content.onChange(of: isPresented) { isPresented in
            if isPresented, alertController == nil {
                let alertController = makeAlertController()
                self.alertController = alertController
                guard let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
                    return
                }
                scene.windows.first?.rootViewController?.present(alertController, animated: true)
            } else if !isPresented, let alertController = alertController {
                alertController.dismiss(animated: true)
                self.alertController = nil
            }
        }
    }

    private func makeAlertController() -> UIAlertController {
        let controller = UIAlertController(title: "Change location manually", message: nil, preferredStyle: .alert)
        controller.addTextField {
            $0.placeholder = "Latitude"
            $0.text = self.latitude
        }
        controller.addTextField {
            $0.placeholder = "Longitude"
            $0.text = self.longitude
        }
        controller.addAction(UIAlertAction(title: "Cancel", style: .cancel) { _ in
            shutdown()
        })
        controller.addAction(UIAlertAction(title: "Change", style: .default) { _ in
            guard let textFields = controller.textFields,
                  let lat = textFields.first?.text,
                  let lon = textFields[1].text else {
                      shutdown()
                      return
                  }
            self.action(lat, lon)
            shutdown()
        })
        return controller
    }

    private func shutdown() {
        isPresented = false
        alertController = nil
    }

}


extension View {

    public func textFieldAlert(isPresented: Binding<Bool>, latitude: String, longitude: String,
                               action: @escaping (String, String) -> Void) -> some View {
        self.modifier(TextFieldAlertModifier(isPresented: isPresented,
                                             latitude: latitude,
                                             longitude: longitude,
                                             action: action))
    }

}
