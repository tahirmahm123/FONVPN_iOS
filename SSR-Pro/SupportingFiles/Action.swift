//
//  Action.swift
//  VPN-Lightning
//
//  Created by Tahir M. on 21/06/2023.
//  Copyright © 2023 Onion Tech Ltd. All rights reserved.
//

import Foundation
final class Action: NSObject {
    
    private let _action: () -> ()
    
    init(action: @escaping () -> ()) {
        _action = action
        super.init()
    }
    
    @objc func action() {
        self._action()
    }
    
}
