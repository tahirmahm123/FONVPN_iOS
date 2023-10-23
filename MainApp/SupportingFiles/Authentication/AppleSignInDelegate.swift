//
//  AppleSignInDelegate.swift
//  AppleSignIn
//
//  Created by Daljeet Singh on 31/07/20.
//  Copyright © 2020 Daljeet Singh. All rights reserved.
//

import Foundation
import AuthenticationServices
import Contacts

final class AppleSignInDelegate: NSObject {
    
    private let signInSucceeded: (ASAuthorizationAppleIDCredential) -> Void
    private weak var window: UIWindow!
    
    init(window: UIWindow?, onSignedIn: @escaping (ASAuthorizationAppleIDCredential) -> Void) {
        self.window = window
        self.signInSucceeded = onSignedIn
    }
}

extension AppleSignInDelegate: ASAuthorizationControllerDelegate {
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        
        switch authorization.credential {
        case let credentials as ASAuthorizationAppleIDCredential:
            if credentials.email != nil, credentials.fullName != nil {
                print("Got an Email: \(String(describing: credentials.email))")
            }
            signInSucceeded(credentials)
        default:
            break
        }
        
    }
    
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("error \(error.localizedDescription)")
            // Handle error.
        
        
        guard let error = error as? ASAuthorizationError else {
            return
        }
        
        switch error.code {
            case .canceled:
                print("Canceled")
            case .unknown:
                print("Unknown")
            case .invalidResponse:
                print("Invalid Respone")
            case .notHandled:
                print("Not handled")
            case .failed:
                print("Failed")
            case .notInteractive:
                print("Not Interactive")
            @unknown default:
                print("Default")
        }
        var code = error.code.rawValue
        if controller.authorizationRequests.count == 2 && code == 1001 {
            code = 9999
        }
        NotificationCenter.default.post(name: .ShowGuestError, object: nil, userInfo: [
            "state": true,
            "message": NSLocalizedString("Sign in with Apple Error \(code)", comment: "")
        ])
    }
    
}

extension AppleSignInDelegate: ASAuthorizationControllerPresentationContextProviding {
  func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
      let app = UIApplication.shared.delegate as! AppDelegate
      let window = app.window
      return window!
  }
}
