//
//  PageView.swift
//
//  Created on 8/07/20.
//  Copyright © 2020 WildAid. All rights reserved.
//

import SwiftUI

struct PageView<Content: View>: View {
    @State var viewControllers: [UIHostingController<Content>]

    @State var currentPage = 0

    init(views: [Content]) {
        self._viewControllers = State(initialValue: views.map { UIHostingController(rootView: $0) })
    }

    var body: some View {
        AnyView(
            ZStack(alignment: .bottom) {
                PageViewController(controllers: viewControllers, currentPage: $currentPage)
                PageControl(numberOfPages: viewControllers.count, currentPage: $currentPage)
            }
        )
    }
}

struct PageView_Previews: PreviewProvider {
    static var previews: some View {
        PageView(views: [Text("First"),
                         Text("Second"),
                         Text("Third")])
    }
}
