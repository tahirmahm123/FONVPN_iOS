//
//  LoginView+Ext.swift
//  VPN-Lightning
//
//  Created by Tahir M. on 04/07/2023.
//  Copyright © 2023 Onion Tech Ltd. All rights reserved.
//

import AuthenticationServices
//import GoogleSignIn
import SwiftUI

enum SocialLoginType {
    case google
    case apple
    case otp
    case custom
}
extension SocialLoginStackView {
    
//    func checkAuthorizationState() {
//        
//        if #available(tvOS 13.0, *) {
//            
//            let appleIDProvider = ASAuthorizationAppleIDProvider()
//            
//            let identifier = keychain.
//            
//            if identifier.isEmpty {
//                return
//            }
//            appleIDProvider.getCredentialState(forUserID: identifier) { (credential, _) in
//                
//                switch credential {
//                    case .authorized:
//                        self.actionState = 1
//                    case .notFound:
//                        self.performExistingAccountSetupFlows()
//                    case .revoked:
//                        keychain.clearKeychain()
//                    case .transferred:
//                        keychain.clearKeychain()
//                    default:
//                        print("Apple sign in credential state unidentified")
//                }
//            }
//        }
//    }
    
    func handleAuthAppleButton(onSuccess: @escaping (() -> Void)) {
        let request = ASAuthorizationAppleIDProvider().createRequest()
        request.requestedScopes = [.fullName, .email]
        appleSignInDelegates = AppleSignInDelegate(window: window) { credentials in
                //            if success {
                //                    // update UI
//            onSuccess()
            print("Update UI")
                //            } else {
                //                    // show the user an error
                //                print("error in perform signin")
                //            }
                // If sign in succeeded, display the app's main content View.
            NotificationCenter.default.post(name: .ShowGuestLoader, object: nil, userInfo: [
                "state": true
            ])
            InternetAvailability.shared.connectivityStatus(completion: { (InternetStatus) -> Void in
                if InternetStatus{
                    ApiManager.shared.appleSSOLogin(String(data:credentials.identityToken!, encoding:.utf8)!, completion: { (auth, isLoginAllowed , isEmailActive, isExpired, isActive) -> Void in
                        NotificationCenter.default.post(name: .ShowGuestLoader, object: nil, userInfo: [
                            "state": false
                        ])
                        appConstants.refreshData()
                        if auth {
                                //                self.invalideCredentialsView.isHidden = true
                            if isActive{
                                if isLoginAllowed  && isEmailActive{
                                    userDefaults.set(true, forKey: isLogedIn)
                                    userDefaults.set(!isExpired, forKey: isPaidUser)
                                    appConstants.generateKeys()
                                        //                                let vc = ControllerHelper.homeVC(nav: router.nav!)
//                                    router.setRoot(views: [LaunchController.vc() ])
                                } else if !isEmailActive {
                                        // to activate email if required
                                }else {
                                }
                            } else {
                                NotificationCenter.default.post(name: .ShowGuestError, object: nil, userInfo: [
                                    "state": true,
                                    "message": "Your account is not active. Please contact support for further assistence."
                                ])
                            }
                        } else {
                            NotificationCenter.default.post(name: .ShowGuestError, object: nil, userInfo: [
                                "state": true,
                                "message": "The email or password you entered is incorrect. Please try again."
                            ])
                        }
                    })
                }else {
                    NotificationCenter.default.post(name: .ShowGuestLoader, object: nil, userInfo: [
                        "state": false
                    ])
                    NotificationCenter.default.post(name: .ShowGuestError, object: nil, userInfo: [
                        "state": true,
                        "message": "Please check your Internet Connection"
                    ])
                    
                }
            })
            return
        }
        let requests = isRegister ? [request] : [request, ASAuthorizationPasswordProvider().createRequest()]
            // Create an authorization controller with the given requests.
        let controller = ASAuthorizationController(authorizationRequests: requests)
        controller.delegate = appleSignInDelegates
        controller.presentationContextProvider = appleSignInDelegates
        controller.performRequests()
    }
        /// Prompts the user if an existing iCloud Keychain credential or Apple ID credential is found.
//    private func performExistingAccountSetupFlows() {
//#if !targetEnvironment(simulator)
//            // Note that this won't do anything in the simulator.  You need to
//            // be on a real device or you'll just get a failure from the call.
//        let requests = [
//            ASAuthorizationAppleIDProvider().createRequest(),
//            ASAuthorizationPasswordProvider().createRequest()
//        ]
//        performAuthApple(using: requests)
//#endif
//    }
    
    
    
    func handleSignInGoogleButton(onSuccess: @escaping ((_ result: Data) -> Void)) {
//        GIDSignIn.sharedInstance.signIn(withPresenting: router.nav!, completion:{(signInResult: GIDSignInResult?, error) in
//            guard let result = signInResult else {
//                    // Inspect error
//                return
//            }
//                // If sign in succeeded, display the app's main content View.
//            NotificationCenter.default.post(name: .ShowGuestLoader, object: nil, userInfo: [
//                "state": true
//            ])
//            InternetAvailability.shared.connectivityStatus(completion: { (InternetStatus) -> Void in
//                if InternetStatus{
//                    ApiManager.shared.googleSSOLogin(result.user.idToken!.tokenString, completion: { (auth, isLoginAllowed , isEmailActive, isExpired, isActive) -> Void in
//                        NotificationCenter.default.post(name: .ShowGuestLoader, object: nil, userInfo: [
//                            "state": false
//                        ])
//                        appConstants.refreshData()
//                        if auth {
//                                //                self.invalideCredentialsView.isHidden = true
//                            if isActive{
//                                if isLoginAllowed  && isEmailActive{
//                                    userDefaults.set(true, forKey: isLogedIn)
//                                    userDefaults.set(!isExpired, forKey: isPaidUser)
//                                    appConstants.generateKeys()
//                                        //                                let vc = ControllerHelper.homeVC(nav: router.nav!)
//                                    router.setRoot(views: [LaunchController.vc() ])
//                                } else if !isEmailActive {
//                                        // to activate email if required
//                                }else {
//                                }
//                            } else {
//                                NotificationCenter.default.post(name: .ShowGuestError, object: nil, userInfo: [
//                                    "state": true,
//                                    "message": "Your account is not active. Please contact support for further assistence."
//                                ])
//                            }
//                        } else {
//                            NotificationCenter.default.post(name: .ShowGuestError, object: nil, userInfo: [
//                                "state": true,
//                                "message": "The email or password you entered is incorrect. Please try again."
//                            ])
//                        }
//                    })
//                }else {
//                    NotificationCenter.default.post(name: .ShowGuestLoader, object: nil, userInfo: [
//                        "state": false
//                    ])
//                    NotificationCenter.default.post(name: .ShowGuestError, object: nil, userInfo: [
//                        "state": true,
//                        "message": "Please check your Internet Connection"
//                    ])
//                    
//                }
//            })
//            return
//        })
    }
    
    func googleSSO() {
        
    }
}
