//
//  LoadingIndicatorView.swift
//
//  Created on 20/03/2020.
//  Copyright © 2020 WildAid. All rights reserved.
//

import SwiftUI

struct LoadingIndicatorView: View {
    @Binding var isAnimating: Bool
    let style: UIActivityIndicatorView.Style

    var body: some View {
        VStack {
            Text("Loading...")
            ActivityIndicator(isAnimating: _isAnimating, style: style)
        }
            .frame(width: 300, height: 200)
            .background(Color.white)
            .foregroundColor(Color.oText)
            .cornerRadius(20)
    }
}

struct LoadingIndicatorView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingIndicatorView(isAnimating: .constant(true), style: .large)
    }
}
