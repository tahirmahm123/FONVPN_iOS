//
//  UIViewController+Ext.swift
//  OnionVPN
//
//  Created by Tahir M. on 03/05/2023.
//  Copyright © 2023 Onion Tech Ltd. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController{
    func showAlert(title: String, message: String, handler: ((UIAlertAction) -> Void)? = nil) {
        self.showErrorAlert(title: title, message: message, handler: handler)
    }
    func showErrorAlert(title: String, message: String, handler: ((UIAlertAction) -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: handler))
        
        present(alert, animated: true, completion: nil)
    }
    func showReconnectPrompt(sourceView: UIView,msg: String = "To apply the new settings, Evolve VPN needs to be reconnected.", confirmed: @escaping (Bool) -> Void) {
        guard !userDefaults.bool(forKey: NotAskToReconnect) else {
            confirmed(true)
            return
        }
        showActionSheet(title:  msg, actions: ["Reconnect", "Reconnect + Don't ask next time"], sourceView: sourceView, disableDismiss: true) { index in
            switch index {
                case 0:
                    confirmed(true)
                case 1:
                    userDefaults.set(true,forKey: NotAskToReconnect)
                    confirmed(true)
                default:
                    confirmed(false)
            }
        }
    }
    func showPortsAndProtocolsPopup(sourceView: UIView , protocolsAndPort : [String], confirmed: @escaping (Int) -> Void) {
        showActionSheet(title: "Preffered Protocol and port?", actions: protocolsAndPort, sourceView: sourceView, disableDismiss: true){ index in
            confirmed(index)
        }
    }
    func showLogoutAllDevicesPopup(sourceView: UIView, confirmed: @escaping (Int) -> Void) {
        showActionSheet(title: "Do you want to logout all other devices?", actions: ["Yes", "No"], sourceView: sourceView, disableDismiss: true){ index in
            switch index {
                case 0:
                    confirmed(0)
                case 1:
                    confirmed(1)
                default:
                    break
            }
        }
    }
    func showLogoutPopup(sourceView: UIView, confirmed: @escaping (Int) -> Void) {
        showActionSheet(title: "Are you sure you want to logout.", actions: ["Log out", "Logout and Remember Me", "Log out and clear settings"], sourceView: sourceView, disableDismiss: true){ index in
            switch index {
                case 0:
                    confirmed(0)
                case 1:
                    confirmed(1)
                default:
                    break
            }
        }
    }
    
//    func presentDetail(_ viewControllerToPresent: UIViewController) {
//        DispatchQueue.main.async {
//            let transition = CATransition()
//            transition.duration = 0.25
//            transition.type = CATransitionType.push
//            transition.subtype = CATransitionSubtype.fromRight
//            if let presentingWindow =  self.view.window{
//                presentingWindow.layer.add(transition, forKey: kCATransition)
//            }
//            self.present(viewControllerToPresent, animated: false)
//        }
//    }
//    
//    func dismissDetail() {
//        let transition = CATransition()
//        transition.duration = 0.25
//        transition.type = CATransitionType.push
//        transition.subtype = CATransitionSubtype.fromLeft
//        self.view.window!.layer.add(transition, forKey: kCATransition)
//        dismiss(animated: false)
//    }
    func showActionSheet(image: UIImage? = nil, selected: String? = nil, largeText: Bool = false, centered: Bool = false, title message: String = "", actions: [String] = [], cancelAction: String = "Cancel", sourceView: UIView = UIView(), disableDismiss: Bool = false, completion: @escaping (_ index: Int) -> Void) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .actionSheet)
        
        let messageFont: [NSAttributedString.Key: Any] = [.font: UIFont.systemFont(ofSize: largeText ? 17 : 16)]
        let messageAttrString = NSMutableAttributedString(string: message, attributes: messageFont)
        alert.setValue(messageAttrString, forKey: "attributedMessage")
        
        for (index, value) in actions.enumerated() {
            let alertAction = UIAlertAction(title: value, style: .default) { _ in
                completion(index)
            }
            
            if let selected = selected {
                if value == selected {
                    let image = UIImage.init(named: "icon-check-2")
                    alertAction.setValue(image, forKey: "image")
                }
            }
            
            alert.addAction(alertAction)
        }
        
        let cancelAction = UIAlertAction(title: cancelAction, style: .cancel) { _ in
            alert.dismiss(animated: true, completion: {
                completion(-1)
            })
        }
        
        alert.addAction(cancelAction)
        
        if let popoverController = alert.popoverPresentationController {
            popoverController.sourceView = sourceView
            popoverController.sourceRect = sourceView.bounds
            if centered {
                popoverController.permittedArrowDirections = []
            }
        }
        
        present(alert, animated: true) {
            if disableDismiss && UIDevice.current.userInterfaceIdiom == .phone {
                alert.view.superview?.subviews[0].isUserInteractionEnabled = false
            }
        }
    }
    
}
