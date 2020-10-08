//
//  Double+CleanValue.swift
//  
//  Created on 10/8/20.
//  Copyright © 2020 WildAid. All rights reserved.
//

import Foundation

extension Double {
    var cleanValue: String {
        return self.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", self) : String(self)
    }
}
