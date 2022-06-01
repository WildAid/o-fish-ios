//
//  MPAView.swift
//  
//  Created on 26.05.2022.
//  Copyright © 2022 WildAid. All rights reserved.
//

import SwiftUI

struct MPAView: View {

    let mpa: MPA
    var onDismiss: () -> Void

    var body: some View {
        VStack {
            HStack(alignment: .top, spacing: 20) {
                ZStack {
                    Circle()
                        .fill(Color(UIColor(hex: mpa.hexColor) ?? .green))

                    Image("map-pin")
                        .resizable()
                        .renderingMode(.template)
                        .foregroundColor(.white)
                        .padding(8)
                }
                .frame(width: 40, height: 40)
                .padding(.leading, 20)

                VStack(alignment: .leading, spacing: 3) {
                    TitleLabel(title: mpa.name)

                    Text(mpa.text)

                    Text(mpa.country)
                        .foregroundColor(.gray)
                }

                Spacer()

                ZStack {
                    Circle()
                        .fill(Color.oDivider)

                    Image(systemName: "xmark")
                        .foregroundColor(Color.oFieldTitle)
                }
                .frame(width: 30, height: 30)
                .padding(.trailing, 20)
                .onTapGesture {
                    onDismiss()
                }
            }
            .frame(maxWidth: .infinity)

            Divider()
                .background(Color.oDivider)

            Text("Rules and Regulations")
                .font(.headline)
                .padding(.horizontal, 20)
                .padding(.bottom, 2)
                .frame(maxWidth: .infinity, alignment: .leading)

            Text(mpa.info)
                .padding(.horizontal, 20)
                .frame(maxWidth: .infinity, alignment: .leading)

            Spacer()
        }
    }
}

struct MPAView_Previews: PreviewProvider {
    static var previews: some View {
        MPAView(mpa: MPA(), onDismiss: {})
    }
}
