//
//  HUDHandler.swift
//  OnionVPN
//
//  Created by Tahir M. on 03/05/2023.
//  Copyright © 2023 Onion Tech Ltd. All rights reserved.
//

import Foundation
import MBProgressHUD
class UIHandler {
    var MBHUD = MBProgressHUD()
    var view: UIView
    init(_ view: UIView) {
        self.view = view
    }
    func showHUDInView(_ view:UIView) -> Void {
        MBProgressHUD.showAdded(to: view, animated: true)
    }
    func showHUD() -> Void {
        MBProgressHUD.showAdded(to: self.view, animated: true)
    }
    func hideHUD() -> Void {
//        MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
    }
    func showHUDWithMessage(message: String) -> Void {
        let progresshud = MBProgressHUD.showAdded(to: self.view, animated: true)
        progresshud.label.text = message
    }
    func showHUDWithCancel() {
        self.MBHUD = MBProgressHUD.showAdded(to: self.view, animated: true)
        self.MBHUD.label.text = "Please wait"
        self.MBHUD.button.setTitle("Stop".lowercased().capitalized, for: .normal)
        self.MBHUD.button.addTarget(self, action: #selector(cancelButton), for: .touchUpInside)
    }
    @objc func cancelButton() {
        self.MBHUD.hide(animated: true)
    }
    func hideKeyboardOnTap() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
