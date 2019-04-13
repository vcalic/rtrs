//
//  Coordinator.swift
//  WRToolbox
//
//  Created by Vlada Calic on 10/29/17.
//  Copyright © 2017 Byrccom. All rights reserved.
//

import UIKit

typealias CoordinatorBlock = (UIViewController) -> Void

protocol Coordinator: class {
    func start(completion: CoordinatorBlock?)
}

struct Coordinators {
    private var coordinators: [Coordinator] = []
    
    mutating func append(coordinator: Coordinator) {
        coordinators.append(coordinator)
    }
    
    mutating func remove(coordinator: Coordinator) {
        coordinators = coordinators.filter { $0 !== coordinator }
    }
    
    mutating func clear() {
        coordinators = []
    }
}

