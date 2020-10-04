//
//  Utils.swift
//  Byrccom
//
//  Created by Vlada Calic on 04/10/2020.
//  Copyright © 2020 Byrccom. All rights reserved.
//

import Foundation

struct JSON {
  static func encodeToData(_ input: Any) -> Data? {
    return try? JSONSerialization.data(withJSONObject: input, options: JSONSerialization.WritingOptions(rawValue: 0))
  }

  static func encode(_ input: Any) -> String {
    let data = JSON.encodeToData(input)
    return data?.stringValue ?? "{}"
  }
}

struct Async {
  static func call<T>(input: T, completion: @escaping(T) -> ()) {
    DispatchQueue.main.async { completion(input) }
  }
}



