//
//  PageScrollView.swift
//
//  Created on 6/07/20.
//  Copyright © 2020 WildAid. All rights reserved.
//

import SwiftUI

struct PageControl: UIViewRepresentable {
    @State var numberOfPages: Int
    @Binding var currentPage: Int

    var currentPageIndicatorTintColor = UIColor.white
    var pageIndicatorTintColor = UIColor.white.withAlphaComponent(0.5)

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIView(context: Context) -> UIPageControl {
        let control = UIPageControl()
        control.numberOfPages = numberOfPages
        control.currentPageIndicatorTintColor = currentPageIndicatorTintColor
        control.pageIndicatorTintColor = pageIndicatorTintColor
        control.addTarget(context.coordinator, action: #selector(Coordinator.updateCurrentPage(sender:)), for: .valueChanged)
        return control
    }

    func updateUIView(_ uiView: UIPageControl, context: Context) {
        uiView.currentPage = currentPage
    }

    class Coordinator: NSObject {
        var control: PageControl

        init(_ control: PageControl) {
            self.control = control
        }

        @objc func updateCurrentPage(sender: UIPageControl) {
            control.currentPage = sender.currentPage
        }
    }
}

struct PageControl_Previews: PreviewProvider {
    static var previews: some View {
        PageControl(numberOfPages: 10, currentPage: .constant(2))
    }
}
