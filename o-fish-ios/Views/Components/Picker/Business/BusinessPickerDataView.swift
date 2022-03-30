//
//  BusinessPickerdataView.swift
//
//  Created on 4/2/20.
//  Copyright © 2020 WildAid. All rights reserved.
//

import SwiftUI

struct BusinessPickerDataView: View {
    let item: BusinessPickerData

    private enum Dimensions {
        static let spacing: CGFloat = 8
        static let verticalPadding: CGFloat = 20
        static let imageSize: CGFloat = 32
    }

    var body: some View {
        VStack(alignment: .leading, spacing: Dimensions.spacing) {
            HStack(alignment: .top, spacing: Dimensions.spacing) {
                Image(systemName: "mappin.and.ellipse")
                    .frame(width: Dimensions.imageSize,
                           height: Dimensions.imageSize,
                           alignment: .center)
                    .foregroundColor(.gray)

                VStack(alignment: .leading, spacing: Dimensions.spacing) {
                    Text(item.business)
                        .font(.callout)
                        .foregroundColor(.oText)
                    Text(item.location)
                        .font(.caption1)
                        .foregroundColor(.oText)
                }

                Spacer()
            }
                .padding(.bottom, Dimensions.verticalPadding)

            Divider()
        }
            .padding(.top, Dimensions.verticalPadding)

    }
}

struct BusinessPickerdataView_Previews: PreviewProvider {
    static let item = BusinessPickerData(business: "P.Sherman",
                                         location: """
                                                  42 Wallaby Way
                                                  Sydney NSW 2000
                                                  Australia
                                                  """)
    static var previews: some View {
        BusinessPickerDataView(item: item)
    }
}
