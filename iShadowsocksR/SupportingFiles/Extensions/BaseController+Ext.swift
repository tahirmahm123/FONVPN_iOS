//
//  Base+Ext.swift
//  OnionVPN
//
//  Created by Tahir M. on 03/05/2023.
//  Copyright © 2023 Onion Tech Ltd. All rights reserved.
//

import Foundation
import UIKit
import MBProgressHUD
import Reachability

protocol BaseController {
    func disconnect()
    func showLoginAgainAlert(caller:UIViewController,title:String?,message:String, confirmed: @escaping (Bool) -> Void) -> Void
    func giveCornerRadiusAndBorder(view: UIView)
    func openLinkInSafari(url: String)
    func openWebViewVC(url: String, viewControler: UIViewController)
    func showNoInternetMessage(_ viewController: UIViewController)
    func showAlert(caller:UIViewController,title:String?,message:String) -> Void
    func showHUDInView(_ view:UIView) -> Void
    func showHUD() -> Void
    func hideHUD() -> Void
    func showHUDWithMessage(message: String) -> Void
    func showHUDWithCancel()
    func generateKeys()
    func getSizeforCell() -> CGFloat
    func resetDefaults()
    func showConnectedAlert(message: String, sender: Any?,confirmed: @escaping (Bool) -> Void)
    func hideKeyboardOnTap()
}

extension BaseController where Self: UIViewController {
    
    var reachability:Reachability? {
        do{
            return try Reachability()
        }catch(let error){
            print(error)
        }
        return nil
    }
    
    var UI: UIHandler {
        return UIHandler(self.view)
    }

    func disconnect() {
        Task {
            await vpn.disconnect()
        }
    }
    func showLoginAgainAlert(caller:UIViewController,title:String?,message:String, confirmed: @escaping (Bool) -> Void) -> Void {
        let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
            UIAlertAction in
            confirmed(true)
        }
        let alert = UIAlertController(title:title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(okAction)
        
        caller.present(alert, animated: true, completion: nil)
    }
    func giveCornerRadiusAndBorder(view: UIView){
        view.layer.cornerRadius = 10
            //        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.init(named: "TableBorderColor")?.cgColor
    }
    func openLinkInSafari(url: String)  {
        guard let url = URL(string: url) else { return }
        UIApplication.shared.open(url)
    }
    func openWebViewVC(url: String, viewControler: UIViewController){
        let vc =  WebViewVC.loadWebViewVC()
        vc.webViewUrl = url
        vc.modalPresentationStyle = .fullScreen
        viewControler.presentDetail(vc)
    }
    func showNoInternetMessage(_ viewController: UIViewController){
        let alert = UIAlertController(title:"No internet!", message: "Please check your connection and try again.", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        viewController.present(alert, animated: true, completion: nil)
    }
    func showAlert(caller:UIViewController,title:String?,message:String) -> Void {
        let alert = UIAlertController(title:title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        caller.present(alert, animated: true, completion: nil)
    }
    func showHUDInView(_ view:UIView) -> Void {
        UI.showHUDInView(view)
    }
    func showHUD() -> Void {
        UI.showHUD()
    }
    func hideHUD() -> Void {
        UI.hideHUD()
    }
    func showHUDWithMessage(message: String) -> Void {
        UI.showHUDWithMessage(message: message)
    }
    func showHUDWithCancel() {
        UI.showHUDWithCancel()
    }
    func generateKeys(){
        InternetAvailability.shared.connectivityStatus(completion: { (InternetStatus) -> Void in
            if InternetStatus{
                if userDefaults.string(forKey: LocalIp) == nil  || userDefaults.string(forKey: LocalIp) == ""{
                    InterfaceForKey.privateKey = Interface.generatePrivateKey()
                    let privateKey = InterfaceForKey.privateKey ?? ""
                    let publicKey = InterfaceForKey.publicKey ?? ""
                    self.showHUD()
                    ApiManager.shared.generateWireGuardKeys(publicKey: publicKey, privateKey: privateKey, completion: { success in
                        self.hideHUD()
                        if success{
                            print("Generated")
                        }
                    })
                }
            }else {
                self.showNoInternetMessage(self)
            }
        })
    }
    func getSizeforCell() -> CGFloat {
        if UIDevice().userInterfaceIdiom == .phone {
            switch UIScreen.main.nativeBounds.height {
                case 1136:
                    return 50
                case 1334:
                    return 55
                case 1920, 2208:
                    return 60
                case 2436:
                    return 65
                case 2688:
                    return 65
                case 1792:
                    return 70
                default:
                    return 75
            }
        } else {
            return 70
        }
    }
    func resetDefaults() {
        userDefaults.setValue(nil, forKey: UserName)
        userDefaults.setValue(nil, forKey: Password)
        userDefaults.setValue(nil, forKey: ApiKey)
        userDefaults.setValue(nil, forKey: ExpiryDate)
        userDefaults.setValue(nil, forKey: SubscriptionPlan)
        userDefaults.setValue(nil, forKey: CERT)
        userDefaults.setValue(nil, forKey: isPaidUser)
        userDefaults.setValue(nil, forKey: isLogedIn)
        userDefaults.setValue(nil, forKey: LastTimeSaved)
        userDefaults.setValue(nil, forKey: LastSelectedServerOVPN)
        userDefaults.setValue(nil, forKey: LastSelectedServerWG)
        userDefaults.setValue(nil, forKey: DiagnosticLogs)
        userDefaults.setValue(nil, forKey: SelectedProtocol)
        userDefaults.setValue(nil, forKey: SelectedProtocolSegment)
        userDefaults.setValue(nil, forKey: DnsOverHT)
        userDefaults.setValue(nil, forKey: DnsEnabled)
        userDefaults.setValue(nil, forKey: CustomDNS)
        userDefaults.setValue(nil, forKey: CustomDNSProtocol)
        userDefaults.setValue(nil, forKey: ResolvedDNSInsideVPN)
        userDefaults.setValue(nil, forKey: ResolvedDNSOutsideVPN)
        userDefaults.setValue(nil, forKey: AntiTracker)
        userDefaults.setValue(nil, forKey: KillSwitch)
        userDefaults.setValue(nil, forKey: SelectRandomServer)
        userDefaults.setValue(nil, forKey: AutoSelectFastServer)
        userDefaults.setValue(nil, forKey: TimeInterval)
        userDefaults.setValue(nil, forKey: SelectedProtocol)
    }
    func showConnectedAlert(message: String, sender: Any?,confirmed: @escaping (Bool) -> Void) {
        if let sourceView = sender as? UIView {
            showActionSheet(title: message, actions: ["Disconnect"], sourceView: sourceView) { index in
                switch index {
                    case 0:
                        self.disconnect()
                        confirmed(true)
                    default:
                        confirmed(false)
                        break
                }
            }
        }
    }
    func hideKeyboardOnTap() {
        UI.hideKeyboardOnTap()
    }
}
