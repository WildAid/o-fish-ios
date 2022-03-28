//
//  ModalView.swift
//
//  Created on 6/26/20.
//  Copyright © 2020 WildAid. All rights reserved.
//

import SwiftUI

struct ModalViewButton: Identifiable {
    var title: String
    var action: () -> Void = {}

    var id: String {
        title
    }
}

extension ModalViewButton: Equatable {
    public static func == (lhs: ModalViewButton, rhs: ModalViewButton) -> Bool {
        lhs.id == rhs.id
    }
}

struct ModalView: View {

    @State var buttons: [ModalViewButton]

    var cancel: () -> Void = {}

    private enum Dimensions {
        static let padding: CGFloat = 8.0
        static let radius: CGFloat = 15.0
        static let bottomPadding: CGFloat = 60.0
    }

    var body: some View {
        VStack(spacing: Dimensions.padding) {
            Spacer()

            VStack(spacing: .zero) {

                ForEach(self.buttons) { button in
                    VStack(spacing: .zero) {
                        ActionSheetButton(title: button.title,
                            radius: 0,
                            action: button.action)

                        if button != self.buttons.last {
                            Divider()
                        }
                    }
                }
                .background(Color.oAltBackground)
            }
                .cornerRadius(Dimensions.radius)
                .padding(.horizontal, Dimensions.padding)

            ActionSheetButton(title: NSLocalizedString("Cancel", comment: ""), action: cancel)
                .font(Font.title3.weight(.semibold))
        }
            .padding(.bottom, Dimensions.bottomPadding)
            .edgesIgnoringSafeArea(.all)
            .background(Color.blackWithOpacity)
    }
}

struct ModalView_Previews: PreviewProvider {
    static var previews: some View {
        ModalView(buttons: [ModalViewButton(title: "Item 1"),
                            ModalViewButton(title: "Item 2"),
                            ModalViewButton(title: "Item 3")])

            .background(Color.black)
    }
}
