//
//  Date+Ext.swift
//  OnionVPN
//
//  Created by Tahir M. on 03/05/2023.
//  Copyright © 2023 Onion Tech Ltd. All rights reserved.
//

import Foundation


extension Date {
    
    static func - (lhs: Date, rhs: Date) -> TimeInterval {
        return lhs.timeIntervalSinceReferenceDate - rhs.timeIntervalSinceReferenceDate
    }
    
    
    private static let logFormat = "yyyy-MM-dd HH:mm:ss"
    private static let fileNameFormat = "yyyy-MM-dd-HHmmss"
    private static let dateFormat = "yyyy-MM-dd"
    private static let dateTimeFormat = "yyyy-MM-dd HH:mm"
    
    static func logTime() -> String {
        return formatted(format: logFormat)
    }
    
    static func logFileName(prefix: String = "") -> String {
        return "\(prefix)\(formatted(format: fileNameFormat))"
    }
    
    static func changeDays(by days: Int) -> Date {
        var dateComponents = DateComponents()
        dateComponents.day = days
        return Calendar.current.date(byAdding: dateComponents, to: Date())!
    }
    
    static func changeMinutes(by minutes: Int) -> Date {
        var dateComponents = DateComponents()
        dateComponents.minute = minutes
        return Calendar.current.date(byAdding: dateComponents, to: Date())!
    }
    
    func changeDays(by days: Int) -> Date {
        var dateComponents = DateComponents()
        dateComponents.day = days
        return Calendar.current.date(byAdding: dateComponents, to: self)!
    }
    
    func changeMinutes(by minutes: Int) -> Date {
        var dateComponents = DateComponents()
        dateComponents.minute = minutes
        return Calendar.current.date(byAdding: dateComponents, to: self)!
    }
    
    func formatDate() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = Date.dateFormat
        return formatter.string(from: self)
    }
    
    func formatDateTime() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = Date.dateTimeFormat
        return formatter.string(from: self)
    }
    
    private static func formatted(format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: Date())
    }
    
    var isPastDate: Bool {
        return self < Date()
    }
}
