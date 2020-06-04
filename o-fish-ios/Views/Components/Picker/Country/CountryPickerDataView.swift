//
//  CountryPickerDataView.swift
//
//  Created on 11/03/2020.
//  Copyright © 2020 WildAid. All rights reserved.
//

import SwiftUI

struct CountryPickerDataView: View {
    let item: CountryPickerData

    private enum Dimensions {
        static let spacing: CGFloat = 8
        static let bottomPadding: CGFloat = 16
        static let imageSize: CGFloat = 32
    }

    var body: some View {
        HStack(spacing: Dimensions.spacing) {
            Text("\(flag(from: item.image).uppercased())")
                .font(.system(size: Dimensions.imageSize))
                .foregroundColor(.white)
                .clipShape(Circle())
                .font(.title)

            Text(item.title)
                .lineLimit(2)
                .foregroundColor(.text)
            Spacer()
        }
            .padding(.top, Dimensions.spacing)
            .padding(.bottom, Dimensions.bottomPadding)
    }

    private func flag(from country: String) -> String {
        let base: UInt32 = 127397 // magic number for transforming country prefix into emoji
        var emojiFlag = ""
        for letter in country.uppercased().unicodeScalars {
            if let element = UnicodeScalar(base + letter.value) {
                emojiFlag.unicodeScalars.append(element)
            }
        }

        return emojiFlag
    }
}

struct CountryPickerDataView_Previews: PreviewProvider {
    static var previews: some View {
        CountryPickerDataView(item: CountryPickerData(image: "FR",
                                                      title: "France"))
    }
}
