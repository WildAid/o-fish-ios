//
//  ViolationRow.swift
//
//  Created on 3/13/20.
//  Copyright © 2020 WildAid. All rights reserved.
//

import SwiftUI

struct ViolationPickerDataView: View {
    let caption: String
    let title: String
    let description: String

    private let horizontalPadding: CGFloat = 8.0
    private let verticalPadding: CGFloat = 10.0
    private let spacing: CGFloat = 4.0

    var body: some View {
        VStack(alignment: .leading, spacing: spacing) {
            Text(LocalizedStringKey(caption))
                .font(.caption)
                .foregroundColor(.gray)
            Text(LocalizedStringKey(title))
                .foregroundColor(.text)
            Text(LocalizedStringKey(description))
                .foregroundColor(.text)
                .font(.footnote)
                .padding(.bottom, verticalPadding)
            Divider()
        }
            .padding(.top, verticalPadding)
            .padding(.horizontal, horizontalPadding)
    }
}

struct ViolationRow_Previews: PreviewProvider {
    static var previews: some View {
        ViolationPickerDataView(caption: "California",
                title: "Fish and Game Code 7857",
                description: "No Commercial License")
    }
}
