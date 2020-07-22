//
// Created by kojiba on 20.07.2020.
// Copyright (c) 2020 WildAid. All rights reserved.
//

import Foundation

class Debouncer {
    private let delay: TimeInterval
    private var workItem: DispatchWorkItem?

    var handler: () -> Void

    init(delay: TimeInterval, handler: @escaping () -> Void) {
        self.delay = delay
        self.handler = handler
    }

    func call() {
        workItem = DispatchWorkItem(block: handler)
        if let task = workItem {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delay, execute: task)
        }
    }

    func invalidate() {
        workItem?.cancel()
        workItem = nil
    }
}
