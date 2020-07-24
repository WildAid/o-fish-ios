//
//  PersonIconView.swift
//
//  Created on 5/21/20.
//  Copyright © 2020 WildAid. All rights reserved.
//

import SwiftUI

struct PersonIconView: View {

    var body: some View {
        Image(systemName: "person.crop.circle.fill")
        .resizable()
        .foregroundColor(.gray)
    }
}

struct PersonIconView_Previews: PreviewProvider {
    static var previews: some View {
        PersonIconView()
    }
}
