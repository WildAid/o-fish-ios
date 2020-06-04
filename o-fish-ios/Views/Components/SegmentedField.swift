//
//  SegmentedField.swift
//
//  Created on 14/04/2020.
//  Copyright © 2020 WildAid. All rights reserved.
//

import SwiftUI

struct SegmentedField: View {
    @Binding var selectedItem: String

    var title: String
    var items: [String]

    var textColor: Color = .main
    var activeColor: Color = .main
    var secondaryColor: Color = .white

    private enum Dimensions {
        static let spacing: CGFloat = 8.0
        static let spacingItem: CGFloat = 16.0
        static let labelSpacing: CGFloat = 10
        static let lineWidth: CGFloat = 1
        static let lineLimit = 1
        static let scaleFactor: CGFloat = 0.7
    }

    var body: some View {
        VStack(spacing: Dimensions.spacing) {
            CaptionLabel(title: title)

            HStack(spacing: Dimensions.spacingItem) {
                ForEach(items) { item in

                    Button(action: { self.selectedItem = item }) {
                        HStack {
                            Spacer(minLength: Dimensions.labelSpacing)
                            Text(LocalizedStringKey(item))
                                .padding(.vertical, Dimensions.labelSpacing)
                                .lineLimit(Dimensions.lineLimit)
                                .foregroundColor(self.selectedItem == item ? self.secondaryColor : self.textColor)
                                .font(self.selectedItem == item ? Font.body.weight(.semibold) : Font.body)
                                .minimumScaleFactor(Dimensions.scaleFactor)
                            Spacer(minLength: Dimensions.labelSpacing)
                        }
                            .background(self.selectedItem == item ? self.activeColor : self.secondaryColor)
                            .cornerRadius(.infinity)
                            .overlay(
                                RoundedRectangle(cornerRadius: .infinity)
                                    .stroke(self.activeColor, lineWidth: Dimensions.lineWidth)
                            )
                    }
                }
            }
                .padding(.bottom, Dimensions.spacing)

            Divider()
        }
    }
}

struct SegmentedField_Previews: PreviewProvider {
    static var previews: some View {
        SegmentedField(selectedItem: .constant("First"), title: "Select For Items", items: ["First", "Second"])
    }
}
