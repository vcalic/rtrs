//
//  ListenerProtocol.swift
//  WRToolbox
//
//  Created by Vlada Calic on 11.7.16..
//  Copyright © 2016. Byrccom. All rights reserved.
//

import Foundation
import ObjectiveC
import Darwin


/********************************************************/
/*                                                      */
/*  var listenerAssocKey = ListenerAssocKeyGenerator()  */
/*                                                      */
/********************************************************/

typealias ListenerAssocKey = UnsafePointer<UInt8>

func ListenerAssocKeyGenerator() -> ListenerAssocKey {
    var r: Int = 0
    arc4random_buf(&r, MemoryLayout<Int>.size)
    return UnsafePointer(bitPattern: r)!
}


protocol Listener {
    var listenerAssocKey: ListenerAssocKey {get set}

    /* Do not implement these */
    var observingArray: [String] {get set}
    func removeObservers()
    func on(_ name:String, block: @escaping ((Notification) -> Void))
}

extension Listener where Self: Any {
    
    var observingArray : [String] {
        get {
            if let retval = objc_getAssociatedObject(self, listenerAssocKey) as? [String] {
                return retval
            } else {
                let newArray : [String] = []
                objc_setAssociatedObject(self, listenerAssocKey, [], objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
                return newArray
            }
        }
        set (newValue) {
            objc_setAssociatedObject(self, &listenerAssocKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    func removeObservers() {
        let center = NotificationCenter.default
        for name in observingArray {
            center.removeObserver(self, name:NSNotification.Name(rawValue: name), object:nil)
        }
    }
            
    func on(_ name: String, block: @escaping ((Notification) -> Void)) {
        let center = NotificationCenter.default
        center.addObserver(forName: NSNotification.Name(rawValue: name), object: nil, queue: nil, using: block)
        var p = observingArray
        p.append(name)
        objc_setAssociatedObject(self, listenerAssocKey, p, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
    }
            
}

