//
//  LogoutModalView.swift
//  
//  Created on 6/25/20.
//  Copyright © 2020 WildAid. All rights reserved.
//

import SwiftUI

struct LogoutModalView: View {
    var logout: () -> Void
    var cancel: () -> Void

    private enum Dimensions {
        static let padding: CGFloat = 8.0
        static let bottomPadding: CGFloat = 60.0
    }

    var body: some View {
        VStack(spacing: Dimensions.padding) {
            Spacer()

            ActionSheetButton(title: "Log Out", color: Color.red, action: logout)

            ActionSheetButton(title: "Cancel", action: cancel)
                .font(Font.title3.weight(.semibold))
                .padding(.bottom, Dimensions.bottomPadding)
        }

    }
}

struct LogoutModalView_Previews: PreviewProvider {
    static var previews: some View {
        LogoutModalView(logout: {}, cancel: {})
            .background(Color.black)
    }
}
