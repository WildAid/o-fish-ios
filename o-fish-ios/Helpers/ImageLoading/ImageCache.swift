//
//  ImageCache.swift
//
//  Created on 23/04/2020.
//  Copyright © 2020 WildAid. All rights reserved.
//

import UIKit

class ImageCache: ObservableObject {
    private let cache = NSCache<NSURL, UIImage>()

    subscript(_ key: URL) -> UIImage? {
        get { cache.object(forKey: key as NSURL) }
        set { newValue == nil ? cache.removeObject(forKey: key as NSURL) : cache.setObject(newValue!, forKey: key as NSURL) }
    }
}
