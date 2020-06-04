//
//  Samplable.swift
//
//  Created on 31/03/2020.
//  Copyright © 2020 WildAid. All rights reserved.
//

protocol Samplable {
    associatedtype Item
    static var sample: Item { get }
}
