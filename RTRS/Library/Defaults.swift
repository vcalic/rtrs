//
//  Defaults.swift
//  Byrccom
//
//  Created by Vlada Calic on 12/27/18.
//  Copyright © 2018 Byrccom. All rights reserved.
//

import Foundation

final class Default {
  fileprivate let defaults = UserDefaults.standard
  static let s = Default()

  subscript(string: String) -> AnyObject? {
    get {
      return defaults.object(forKey: string) as AnyObject?
    }
    set {
      defaults.set(newValue, forKey: string)
      defaults.synchronize()
    }
  }
}
