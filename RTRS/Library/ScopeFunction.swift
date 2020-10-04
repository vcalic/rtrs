//
//  ScopeFunction.swift
//  Byrccom
//
//  Created by Vlada Calic on 4/14/19.
//  Copyright © 2019 Byrccom. All rights reserved.
//

/* Kotlin-like scope function */

/*
 * Example:

    let view = UIView().apply {
        $0.backgroundColor = .red
        $0.frame = .init(x: 0, y: 0, width: 200, height: 200)
    }
 */

import Foundation
public protocol Appliable {}
public extension Appliable {
  @discardableResult
  func apply(_ closure: (Self) -> Void) -> Self {
    closure(self)
    return self
  }
}

public protocol Runnable {}
public extension Runnable {
  @discardableResult
  func run<T>(closure: (Self) -> T) -> T {
    return closure(self)
  }
}

extension NSObject: Appliable {}
extension NSObject: Runnable {}
