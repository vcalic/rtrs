//
//  Mustache.swift
//  RTRS
//
//  Created by Vlada Calic on 2/27/19.
//  Copyright © 2019 Byrccom. All rights reserved.
//

import Foundation
import JavaScriptCore

struct Mustache {
  let url: URL
    
  init() throws {
    if let _url = Bundle.main.url(forResource: "mustache", withExtension: "js") {
      url = _url
    } else {
      throw AppError.missingMustache
    }
  }
    
  func perform() {
    let context = createContext()
    context.evaluateScript(try? String(contentsOf: url), withSourceURL: url)
  }
    
  private func createContext() -> JSContext {
    let context = JSContext()!
    context.exceptionHandler = { _, exception in
      /* if let _exception = exception, let message = _exception.toString() {
       print(message)
       } */
      do {
        let ex = try exception.or(MError())
        let mess = try ex.toString().or(MError())
        print("\(mess)")
      } catch {
        debugPrint("JSContext exception: \(error)")
      }
    }
        
    return context
  }
    
  private func example() {
    let context = createContext()

    context.evaluateScript("""
    function triple(number) {
        return number * 3;
    }
    """)
        
    context.evaluateScript("var threeTimesFive = triple(5)")
        
    let t = context.objectForKeyedSubscript("threeTimesFive")?
      .toInt32() // 15
    debugPrint("Result: \(String(describing: t))")
        
    let triple = context.objectForKeyedSubscript("triple")
    if let z = triple?.call(withArguments: [9])?.toInt32() {
      debugPrint("Z: \(z)")
    }
        
    let quadruple: @convention(block) (Int) -> Int = { input in
      input * 4
    }
        
    context.setObject(quadruple, forKeyedSubscript: "quadruple" as NSString)
        
    if let k = context.evaluateScript("quadruple(3)")?.toInt32() {
      debugPrint("K je \(k)")
    }
  }
}

class MError: Error {}
