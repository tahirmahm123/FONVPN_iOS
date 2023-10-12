//
//  UIButton+Ext.swift
//  VPN-Lightning
//
//  Created by Tahir M. on 06/05/2023.
//  Copyright © 2023 Onion Tech Ltd. All rights reserved.
//

import Foundation
import UIKit

private var actionKey: Void?

extension UIButton {
    
    private var _action: () -> Void {
        get {
            return objc_getAssociatedObject(self, &actionKey) as! () -> Void
        }
        set {
            objc_setAssociatedObject(self, &actionKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    func addAction(_ action: @escaping () -> Void, for controlEvents: UIControl.Event) {
        self._action = action
        self.addTarget(self, action: #selector(pressed), for: controlEvents)
    }
    
    @objc private func pressed(sender: UIButton) {
        _action()
    }
    
}
