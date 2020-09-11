//
//  FindRecordsButtonView.swift
//  
//  Created on 9/8/20.
//  Copyright © 2020 WildAid. All rights reserved.
//

import SwiftUI

struct FindRecordsButtonView: View {

    var action: (() -> Void)?

    private enum Dimensions {
        static let spacing: CGFloat = 5.0
        static let width: CGFloat = 90.0
    }

    var body: some View {
        Button(action: action ?? {}) {
            VStack(spacing: Dimensions.spacing) {
                Image(systemName: "magnifyingglass")
                    .font(.title2)
                Text("Find Records")
                    .font(.caption1)
                    .lineLimit(2)
                    .multilineTextAlignment(.center)
            }
                .foregroundColor(Color.removeAction)
        }
            .frame(width: Dimensions.width)
    }
}

struct FindRecordsButtonView_Previews: PreviewProvider {
    static let localizations = Bundle.main.localizations.map(Locale.init).filter { $0.identifier != "base" }

    static var previews: some View {
        Group {
            ForEach(localizations, id: \.identifier) { locale in
                FindRecordsButtonView()
                    .previewLayout(PreviewLayout.sizeThatFits)
                    .padding()
                    .environment(\.locale, locale)
                    .previewDisplayName(Locale.current.localizedString(forIdentifier: locale.identifier))
            }
        }
    }
}
