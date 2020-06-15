//
//  Dictionary+safe.swift
//  MomentSnap
//
//  Created by Victor Pop on 15/12/16.
//  Copyright © 2016 MomentSnap. All rights reserved.
//

import Foundation

extension Dictionary where Key: ExpressibleByStringLiteral {

    func stringFor(_ keyName: Key, defaultTo: String = "") -> String {
        guard let stringForKey = self[keyName] as? String else {
            if let intVal = self[keyName] as? Int {
                return "\(intVal)"
            }
            if let float = self[keyName] as? Float  {
                return "\(float)"
            }
            
            return defaultTo
        }

        return stringForKey
    }

    func intFor(_ keyName: Key, defaultTo: Int = -1) -> Int {
        if let intForKey = self[keyName] as? Int {
            return intForKey
        }
        else if let intForKey = self[keyName] as? String {
            return intForKey.intValue(defaultTo:defaultTo)
        }
        else {
            return defaultTo
        }

       
    }

    func floatFor(_ keyName: Key, defaultTo: Float = -1.0) -> Float {
        if let floatForKey = self[keyName] as? Float {
            return floatForKey
        }
        if let floatForKey = self[keyName] as? Double {
            return Float( floatForKey)
        }
        if let floatForKey = self[keyName] as? Int {
            return Float( floatForKey)
        }
        if let floatForKey = self[keyName] as? String {
            if let val = floatForKey.floatValue(defaultVal: defaultTo) {
                return val
            }
        }

        return defaultTo
    }

    func boolFor(_ keyName: Key, defaultTo: Bool = false) -> Bool {
        if let boolForKey = self[keyName] as? Bool {
            return boolForKey
        }
        if let boolForKey = self[keyName] as? String {
            return boolForKey.boolValue()
        }
        if let boolForKey = self[keyName] as? Int {
            return boolForKey == 1
        }

        return defaultTo
    }
}
