//
//  ControllerHelper.swift
//  VPN-Lightning
//
//  Created by Tahir M. on 05/07/2023.
//  Copyright © 2023 Onion Tech Ltd. All rights reserved.
//

import UIKit
import SwiftUI


class ControllerHelper {
//    static func getStartedVC() -> UIViewController {
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let vc = storyboard.instantiateViewController(withIdentifier: "GetStartedScreen")
//        return vc
//    }
//    
    static func getStartedVC(nav: UINavigationController, login: Bool = false) -> UIViewController {
        let vc = UIHostingController(rootView: MainRootView(nav: nav, view: AnyView(GetStarted(showLogin: login))))
        vc.title = "Application Screen"
        return vc
    }
    
    static func homeVC(nav: UINavigationController) -> UIViewController {
        let vc = UIHostingController(rootView: MainRootView(nav: nav, view: AnyView(HomePageView())))
        vc.title = "Application Screen"
        return vc
    }
    
    static func loginVC(nav: UINavigationController) -> UIViewController {
//        nav.navigationBar.isHidden = false
        let vc = UIHostingController(rootView: MainRootView(nav: nav, view: AnyView(LoginScreen())))
        vc.title = "Sign in with your Email"
        vc.navigationItem.backButtonTitle = "Back"
        return vc
    }
    
    
    static func loginAccountIDVC(nav: UINavigationController) -> UIViewController {
        nav.navigationBar.isHidden = false
        let vc = UIHostingController(rootView: MainRootView(nav: nav, view: AnyView(LoginScreen(loginWithAccountID: true))))
        vc.title = "Sign in with Account ID"
        vc.navigationItem.backButtonTitle = "Back"
        return vc
    }
//    static func loginStoredEmailVC(nav: UINavigationController) -> UIViewController {
//        nav.navigationBar.isHidden = false
//        let vc = UIHostingController(rootView: MainRootView(nav: nav, view: AnyView(StoredEmailLoginView())))
//        vc.title = ""
//        vc.navigationItem.backButtonTitle = "Back"
//        return vc
//    }
//    static func loginPasswordVC(nav: UINavigationController) -> UIViewController {
//        nav.navigationBar.isHidden = false
//        let vc = UIHostingController(rootView: MainRootView(nav: nav, view: AnyView(PasswordLoginView())))
//        vc.title = ""
//        vc.navigationItem.backButtonTitle = "Back"
//        return vc
//    }
    static func registerVC(nav: UINavigationController) -> UIViewController {
        nav.navigationBar.isHidden = false
        let vc = UIHostingController(rootView: MainRootView(nav: nav, view: AnyView(RegisterScreen())))
        vc.title = "Create Account"
//        vc.navigationItem.backButtonTitle = "Back"
        return vc
    }
//    static func registerPasswordVC(nav: UINavigationController) -> UIViewController {
//        nav.navigationBar.isHidden = false
//        let vc = UIHostingController(rootView: MainRootView(nav: nav, view: AnyView(PasswordRegisterView())))
//        vc.title = ""
//        vc.navigationItem.backButtonTitle = "Back"
//        return vc
//    }
}
