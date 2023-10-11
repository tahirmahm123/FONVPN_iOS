//
//  Error+Ext.swift
//  OnionVPN
//
//  Created by Tahir M. on 03/05/2023.
//  Copyright © 2023 Onion Tech Ltd. All rights reserved.
//

import Foundation

extension Error {
    var code: Int { return (self as NSError).code }
}
