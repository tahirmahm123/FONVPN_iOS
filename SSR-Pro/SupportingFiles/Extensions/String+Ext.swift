//
//  String.swift
//  OnionVPN
//
//  Created by Tahir M. on 03/05/2023.
//  Copyright © 2023 Onion Tech Ltd. All rights reserved.
//

import Foundation
import UIKit

extension String {
    
    func commaSeparatedToArray() -> [String] {
        return components(separatedBy: .whitespaces)
            .joined()
            .split(separator: ",")
            .map(String.init)
    }
    
    func trim() -> String {
        return trimmingCharacters(in: CharacterSet.whitespaces)
    }
    
    func deletingPrefix(_ prefix: String) -> String {
        guard self.hasPrefix(prefix) else {
            return self
        }
        
        return String(self.dropFirst(prefix.count))
    }
    
    func deletingSuffix(_ suffix: String) -> String {
        guard self.hasSuffix(suffix) else {
            return self
        }
        
        return String(self.dropLast(suffix.count))
    }
    
    func base64KeyToHex() -> String? {
        let base64 = self
        
        guard base64.count == 44 else {
            return nil
        }
        
        guard base64.last == "=" else {
            return nil
        }
        
        guard let keyData = Data(base64Encoded: base64) else {
            return nil
        }
        
        guard keyData.count == 32 else {
            return nil
        }
        
        let hexKey = keyData.reduce("") {$0 + String(format: "%02x", $1)}
        
        return hexKey
    }
    
    func updateAttribute(key: String, value: String) -> String {
        var array = [String]()
        for setting in self.components(separatedBy: "\n") {
            if setting.hasPrefix(key) {
                array.append("\(key)=\(value)")
            } else {
                array.append(setting)
            }
        }
        return array.joined(separator: "\n")
    }
    
    
    func camelCaseToCapitalized() -> String? {
        let pattern = "([a-z0-9])([A-Z])"
        
        let regex = try? NSRegularExpression(pattern: pattern, options: [])
        let range = NSRange(location: 0, length: count)
        return regex?.stringByReplacingMatches(in: self, options: [], range: range, withTemplate: "$1 $2").lowercased().capitalized
    }
    
    func base64ToImage() -> UIImage? {
        if let url = URL(string: self), let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
            return image
        }
        
        return nil
    }
    
    var length: Int {
        return count
    }
    
    subscript (i: Int) -> String {
        return self[i ..< i + 1]
    }
    
    func substring(fromIndex: Int) -> String {
        return self[min(fromIndex, length) ..< length]
    }
    
    func substring(toIndex: Int) -> String {
        return self[0 ..< max(0, toIndex)]
    }
    
    subscript (r: Range<Int>) -> String {
        let range = Range(uncheckedBounds: (lower: max(0, min(length, r.lowerBound)),
                                            upper: min(length, max(0, r.upperBound))))
        let start = index(startIndex, offsetBy: range.lowerBound)
        let end = index(start, offsetBy: range.upperBound - range.lowerBound)
        return String(self[start ..< end])
    }
    
    func isValidEmail() -> Bool {
            // Create a regular expression pattern to match the email format
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        do {
                // Create a regular expression object using the emailRegex pattern
            let regex = try NSRegularExpression(pattern: emailRegex)
                // Check if the email matches the regular expression pattern
            let matches = regex.matches(in: self, range: NSRange(location: 0, length: self.count))
            return matches.count > 0
        } catch {
                // Handle any errors that occur when creating the regular expression object
            return false
        }
    }
}
