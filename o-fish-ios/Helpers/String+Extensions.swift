//
//  String+Extensions.swift
//  
//  Created on 10/9/20.
//  Copyright © 2020 WildAid. All rights reserved.
//

import Foundation

public func NSLocalizedString(_ key: String) -> String {
    return NSLocalizedString(key, comment: key)
}

extension String {

    public static var empty: String {
        return ""
    }
}

extension Optional where Wrapped == String {

    public var isNilOrEmpty: Bool {
        if let value = self {
            return (value.count == 0)
        }

        return true
    }
}
