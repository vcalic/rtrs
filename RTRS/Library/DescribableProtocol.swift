//
//  DescribableProtocol.swift
//  RTRS
//
//  Created by Vlada Calic on 14.6.16..
//  Copyright © 2016. Wireless Media. All rights reserved.
//

import Foundation

// MARK: - JSON Serializable protocol
// MARK: -

/* JSONSerializable uzeto odavde: http://codelle.com/blog/2016/5/an-easy-way-to-convert-swift-structs-to-json/ */

protocol JSONRepresentable {
    var JSONRepresentation: AnyObject { get }
}

protocol JSONSerializable: JSONRepresentable { }

extension JSONSerializable {
    var JSONRepresentation: AnyObject {
        var representation = [String: AnyObject]()
        
        for case let (label?, value) in Mirror(reflecting: self).children {
            switch value {
                
            case let value as Date:
                representation[label] = value.isoString() as AnyObject?
                
            case let value as JSONRepresentable:
                representation[label] = value.JSONRepresentation
                
            case let value as NSObject:
                representation[label] = value
                
            default:
                // Ignore any unserializable properties
                break
            }
        }
        
        return representation as AnyObject
    }
}

extension JSONSerializable {
    func toJSON() -> String? {
        let representation = JSONRepresentation
        
        guard JSONSerialization.isValidJSONObject(representation) else {
            NSLog("Guared not isValid \(representation)")
            return nil
        }
        
        do {
            let data = try JSONSerialization.data(withJSONObject: representation, options: [])
            return String(data: data, encoding: String.Encoding.utf8)
        } catch {
            NSLog("JSON serialization carsh")
            return nil
        }
    }
}

/* End of JSONSerializable */

// MARK: - Describable protocol
// MARK: -

/* Describable protocol */
/* Ideja: https://medium.com/swift-programming/struct-style-printing-of-classes-in-swift-7ee34f1c975a#.bddiu3hy8 */

public protocol Describable : CustomStringConvertible { }

extension Describable {
    public var description: String {
        let mirror = Mirror(reflecting: self)
        
        var str = "\(mirror.subjectType)(\n"
        var first = true
        for (label, value) in mirror.children {
            if let label = label {
                if first {
                    first = false
                } else {
                    str += ", \n"
                }
                str += "\t\(label): \(value)"
            }
        }
        str += "\n)"
        return str
    }
}

