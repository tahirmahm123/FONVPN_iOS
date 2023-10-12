//
//  URL+Ext.swift
//  OnionVPN
//
//  Created by Tahir M. on 03/05/2023.
//  Copyright © 2023 Onion Tech Ltd. All rights reserved.
//

import Foundation

extension URL {
    
    func getTopLevelSubdomain() -> String {
        if let hostName = host {
            let subStrings = hostName.components(separatedBy: ".")
            var domainName = ""
            let count = subStrings.count
            
            if count > 2 {
                domainName = subStrings[count - 3] + "." + subStrings[count - 2] + "." + subStrings[count - 1]
            } else if count <= 2 {
                domainName = hostName
            }
            
            return domainName
        }
        
        return ""
    }
    
}
