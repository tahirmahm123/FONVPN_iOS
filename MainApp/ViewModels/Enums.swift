//
//  Enums.swift
//  VPN-Lightning
//
//  Created by Tahir M. on 28/05/2023.
//  Copyright © 2023 Onion Tech Ltd. All rights reserved.
//

import Foundation
enum LogoutSheetAction {
    case logout
    case rememberMeWithLougout
    case logoutWithReset
}
enum ProtocolType: Int {
    case openvpn
    case wireguard
    case ikev2
//    case automatic
}
