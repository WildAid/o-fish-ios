//
//  Array_OptionalAppend.swift
//
//  Created on 22/04/2020.
//  Copyright © 2020 WildAid. All rights reserved.
//

import Foundation

extension Array {
    public mutating func append(_ newElement: Element?) {
        if let element = newElement {
            self.append(element)
        }
    }
}
