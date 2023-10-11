//
//  SocialLoginStackView.swift
//  VPN-Lightning
//
//  Created by Tahir M. on 18/07/2023.
//  Copyright © 2023 Onion Tech Ltd. All rights reserved.
//

import SwiftUI

struct SocialLoginStackView: View {
    @Environment(\.window) var window: UIWindow?
    @State var appleSignInDelegates: AppleSignInDelegate! = nil
    @EnvironmentObject var router: AppRouter
    @EnvironmentObject var appConstants: AppConstants
    var isRegister = false
    var body: some View {
        SocialLoginButton(action: {
            handleSignInGoogleButton(onSuccess: {profile in
                print("Google Sign In")
            })
        }) {
            HStack {
                Image("GoogleIcon")
                Text("Sign \(isRegister ? "up" :"in") with Google")
            }
            .padding(.vertical)
        }
        SocialLoginButton(action: {
            handleAuthAppleButton(onSuccess: {
                print("Apple Sign In")
            })
        }) {
            HStack {
                Image("AppleIcon")
                Text("Sign \(isRegister ? "up" :"in") with Apple")
            }
            .padding(.vertical)
        }
            //                            SocialLoginButton(action: {
            //
            //                            }) {
            //                                HStack {
            //                                    Image("KeyIcon")
            //                                    Text("Sign in with OTP")
            //                                }
            //                                .padding(.vertical)
            //                            }
    }
}


struct SocialLoginStackView_Previews: PreviewProvider {
    static var previews: some View {
        SocialLoginStackView()
            .environmentObject(AppConstants.shared)
            //            .environmentObject(AppConstants.shared)
            //            .environmentObject(ApiManager.shared)
    }
}
