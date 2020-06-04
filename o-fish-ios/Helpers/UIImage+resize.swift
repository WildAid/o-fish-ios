//
//  UIImage+resize.swift
//
//  Created on 3/26/20.
//  Copyright © 2020 WildAid. All rights reserved.
//

import UIKit

extension UIImage {
    func resize(scale: CGFloat) -> UIImage {
        let scaledSize = CGSize(width: self.size.width * scale,
                                height: self.size.height * scale)

        UIGraphicsBeginImageContextWithOptions(scaledSize, false, 0.0)
        self.draw(in: CGRect(x: 0.0, y: 0.0, width: scaledSize.width, height: scaledSize.height))
        guard let image = UIGraphicsGetImageFromCurrentImageContext() else {
            return self
        }
        UIGraphicsEndImageContext()
        return image
    }
}
