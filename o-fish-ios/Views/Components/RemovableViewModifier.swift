//
//  RemovableViewModifier.swift
//
//  Created on 6/1/20.
//  Copyright © 2020 WildAid. All rights reserved.
//

import SwiftUI

struct RemovableViewModifier: ViewModifier {

    var isActive: Bool
    var action: () -> Void

    @State private var showingRemove = false

    private enum Dimensions {
        static let spacing: CGFloat = 8.0
        static let trailingPadding: CGFloat = -16.0
        static let noPadding: CGFloat = 0.0
    }

    func body(content: Content) -> some View {

        HStack(spacing: Dimensions.spacing) {
            content

                if self.showingRemove {
                    Button(action: self.action) {
                        VStack {
                            Spacer()
                            Image(systemName: "trash")
                            Text(NSLocalizedString("Remove", comment: ""))
                            Spacer()
                        }
                    }
                        .padding(.horizontal, Dimensions.spacing)
                        .background(Color.red)
                        .foregroundColor(Color.white)
                        .transition(.slide)
                }
        }
            .padding(.trailing, showingRemove ? Dimensions.trailingPadding : Dimensions.noPadding)
            .gesture(DragGesture()
            .onChanged({ value in
                if value.translation.width < 0 && self.isActive {
                    withAnimation {
                        self.showingRemove = true
                    }
                }
                if value.translation.width > 0 {
                    withAnimation {
                        self.showingRemove = false
                    }
                }
            })
            )
            .onTapGesture {
                withAnimation {
                    self.showingRemove = false
                }
        }
    }
}

extension View {
    func removable(isActive: Bool = true, with action: @escaping () -> Void) -> some View {
        self.modifier(RemovableViewModifier(isActive: isActive, action: action))
    }
}

struct DeletableView_Previews: PreviewProvider {
    static var previews: some View {
        wrappedShadowView {
            EMSSummaryView(ems: .sample, isEditable: true)
                .removable {}
        }
    }
}
