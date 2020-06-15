//
//  StingExtension.swift
//  MomentSnap
//
//  Created by Abhishek Sharma on 30/10/18.
//  Copyright © 2018 MomentSnap. All rights reserved.
//

import Foundation
import UIKit

extension String {
    /// Convetrts String to bool
    ///
    /// - Returns: Bool value
    func boolValue() -> Bool {
        if self == "True" || self == "1" || self == "true" || self == "Yes" || self == "yes" {
            return true
        }
        else if self == "False" || self == "0" || self == "false" || self == "No" || self == "no" {
            return false
        }
        return false
    }
    
    
    /// Convert String to Int
    ///
    /// - Returns: returns Int value or 0
    func intValue(defaultTo:Int = 0) -> Int {
        if let value = Int(self) {
            return value
        }
        if let value = Float(self) {
            return Int(value)
        }
        return defaultTo
    }
    
    
    /// Convert String to Float
    ///
    /// - Returns: Returns: returns Float value or 0
    func floatValue() -> Float {
        if let value = Float(self) {
            return value
        }
        return 0.0
    }
    
    func floatValue(defaultVal: Float? = nil) -> Float? {
        if let float = Float(self) {
            return float
        }
        guard let defVal = defaultVal else {
            return nil
        }
        return defVal
    }
    
    /// Convert String to Float
    ///
    /// - Returns: Returns: returns Float value or 0
    func cgFloatValue() -> CGFloat {
        if let value = Float(self) {
            return CGFloat(value)
        }
        return CGFloat(0.0)
    }
    
    
    /// Convert String to Double
    ///
    /// - Returns: Returns: returns Double value or 0
    
    func doubleValue() -> Double {
        if let value = Double(self) {
            return value
        }
        return 0.0
    }
    
    /// To return always a valid String Object
    ///
    /// - Returns: self os empty String
    func nonNullValue() -> String {
        if self == "(null)" || self == "null" || self == "(Null)" || self == "(NULL)" || self == "NULL" || self == "Null" {
            return""
        }
        return self
    }
    
    
    /// Checkes if String value is nonEmpty and non nil
    ///
    /// - Parameter string: Optional String
    /// - Returns: if string is empty
    static func isEmptyString(string: String?) -> Bool {
        guard let str = string else {
            return true
        }
        return str.isEmpty
    }
    
    //
    /// UrlEncodes string
    /// must be used while sending string to web services
    /// - Returns: url encoded string
    func urlEncoded() -> String {
        if let encoded = self.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) {
            return encoded
        }
        print("Not Able to encode)")
        return ""
    }
    
    func dateWithFormatA(format:String = "yyyy-MM-dd'T'HH:mm:ss") -> Date? {
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = format
        dateFormater.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale
        dateFormater.timeZone = TimeZone(abbreviation: "UTC")
        var str = self.substring(to: self.index(self.startIndex, offsetBy: String.IndexDistance(19)))
        return dateFormater.date(from: str)
    }
    
    func localDateWithFormat(format:String = "yyyy-MM-dd'T'HH:mm:ss") -> Date? {
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = format
        dateFormater.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale
        //dateFormater.timeZone = TimeZone(abbreviation: "UTC")
        var str = self.substring(to: self.index(self.startIndex, offsetBy: String.IndexDistance(19)))
        return dateFormater.date(from: str)
    }
    
    func dateWithFormat(format:String = "yyyy-MM-dd'T'HH:mm:ss.sss'Z'",isLocal:Bool = false) -> Date? {
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = format
        dateFormater.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale
        if !isLocal {
            dateFormater.timeZone = TimeZone(abbreviation: "UTC")
        }
//        else {
//            dateFormater.timeZone = TimeZone.current
//        }
        var date = self
        if self.components(separatedBy: "T").count > 1 {
            dateFormater.dateFormat = "yyyy-MM-dd"
            date = self.components(separatedBy: "T").first!
        }
        return dateFormater.date(from: date)
    }
    
    
    
    
}
