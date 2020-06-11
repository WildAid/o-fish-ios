//
//  UIView+Constraints.swift
//
//  Created on 10/06/2020.
//  Copyright © 2020 WildAid. All rights reserved.
//

import UIKit

extension UIView {
    func bindFrameToSuperviewBounds(leading: CGFloat = 0,
                                    trailing: CGFloat = 0,
                                    top: CGFloat = 0, bottom: CGFloat = 0) {
        guard let superview = self.superview else {
            print("Error! `superview` was nil – call `addSubview(view: UIView)` before calling `bindFrameToSuperviewBounds()` to fix this.")
            return
        }

        self.translatesAutoresizingMaskIntoConstraints = false
        superview.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(\(leading))-[subview]-\(trailing)-|",
            options: .directionLeadingToTrailing, metrics: nil, views: ["subview": self]))
        superview.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-(\(top))-[subview]-\(bottom)-|",
            options: .directionLeadingToTrailing, metrics: nil, views: ["subview": self]))
    }
}
