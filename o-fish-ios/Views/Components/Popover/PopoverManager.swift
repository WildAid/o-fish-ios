//
//  PopoverManager.swift
//
//  Created on 10/06/2020.
//  Copyright © 2020 WildAid. All rights reserved.
//

import SwiftUI

class PopoverManager {
    static var shared = PopoverManager()

    var currentlyShowingPopovers: [String: UIViewController] = [:]

    func showPopover<Popover: View>(id: String, content: () -> Popover, withButton: Bool = true) {

        let hidePopoverAction = {
            self.hidePopover(id: id)
        }

        let view = VStack(spacing: .zero) {
            if withButton {
                Button(action: hidePopoverAction) {
                    Color.clear
                }
                Spacer(minLength: .zero)
            }
            content()
        }
            .edgesIgnoringSafeArea(.all)
            .background(Color.clear)

        let hosting = UIHostingController(rootView: view)

        let hostingView = hosting.view as UIView

        hostingView.translatesAutoresizingMaskIntoConstraints = false
        hostingView.backgroundColor = .clear

        let firstWindow = UIApplication.shared.windows.first
        firstWindow?.addSubview(hostingView)

        hostingView.bindFrameToSuperviewBounds()
        currentlyShowingPopovers[id] = hosting
    }

    func hidePopover(id: String) {
        guard let controller = currentlyShowingPopovers[id] else { return }
        controller.view.removeFromSuperview()
        currentlyShowingPopovers.removeValue(forKey: id)
    }
}

// TODO: uncomment when this type of modifier will be able to work
//struct PopoverModifier<Overlay: View>: ViewModifier {
//
//    @State var id = UUID().uuidString
//    @Binding var showing: Bool
//    var popover: () -> Overlay
//
//    private func checkStatus() {
//        if self.showing {
//            PopoverManager.shared.showPopover(id: self.id, content: self.popover)
//        } else {
//            PopoverManager.shared.hidePopover(id: self.id)
//        }
//    }
//
//    func body(content: Content) -> some View {
//            content
//                .onAppear(perform: self.checkStatus)
//    }
//}
//
//extension View {
//
//    func popover<Popover: View>(showing: Binding<Bool>, popover: @escaping () -> Popover) -> some View {
//        modifier(
//            PopoverModifier<Popover>(showing: showing, popover: popover)
//        )
//    }
//}

struct PopoverManager_Previews: PreviewProvider {
    static var previews: some View {
        /*@START_MENU_TOKEN@*/Text("Hello, World!")/*@END_MENU_TOKEN@*/
    }
}
