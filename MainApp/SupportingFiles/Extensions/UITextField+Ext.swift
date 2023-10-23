//
//  UITextField+Ext.swift
//  OnionVPN
//
//  Created by Tahir M. on 03/05/2023.
//  Copyright © 2023 Onion Tech Ltd. All rights reserved.
//

import Foundation
import UIKit

extension UITextField {
    
    func enablePasswordToggle(){
        
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "eye"), for: .normal)
        button.setImage(UIImage(named: "eye-slash"), for: .selected)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -20, bottom: 0, right: 0)
        button.addTarget(self, action: #selector(togglePasswordView), for: .touchUpInside)
        rightView = button
        rightViewMode = .always
        button.alpha = 1
    }
    
    @objc func togglePasswordView(_ sender: UIButton) {
        isSecureTextEntry.toggle()
        sender.isSelected.toggle()
    }
    
    func setLeftPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    func setRightPaddingPoints(_ amount:CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
}
