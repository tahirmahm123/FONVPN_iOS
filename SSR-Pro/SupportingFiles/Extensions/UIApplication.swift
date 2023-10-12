//
//  UIApplication.swift
//  VPN-Lightning
//
//  Created by Tahir M. on 02/07/2023.
//  Copyright © 2023 Onion Tech Ltd. All rights reserved.
//

import UIKit
extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
