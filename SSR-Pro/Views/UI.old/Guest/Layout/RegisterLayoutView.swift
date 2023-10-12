//
//  RegisterViewLayout.swift
//  VPN-Lightning
//
//  Created by Tahir M. on 10/07/2023.
//  Copyright © 2023 Onion Tech Ltd. All rights reserved.
//

import Foundation
import SwiftUI

struct RegisterLayoutView<Content: View>: View {
    @EnvironmentObject var appConstants: AppConstants
    @EnvironmentObject var router: AppRouter
    @Environment(\.window) var window: UIWindow?
    @State var appleSignInDelegates: AppleSignInDelegate! = nil
    @ViewBuilder var content: Content
    var showSocialButtons: Bool
    var title: String
    init(title: String, socialButtons: Bool = true, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
        self.showSocialButtons = socialButtons
    }
    var body: some View {
        BasicLayoutView(title: title) {
            VStack(spacing: 20) {
                content
            }
            Spacer()
            
            VStack( spacing: 20) {
                if showSocialButtons {
                    SocialLoginStackView(isRegister: true)
                }
                Spacer()
                HStack(alignment: .center) {
                    Spacer()
                    Text("Already have an account?")
                    Button(action: {
                        router.pushTo(view: ControllerHelper.loginEmailVC(nav: router.nav!))
                    }) {
                        Text("Login")
                            .foregroundColor(Color("AccentColor"))
                    }
                    Spacer()
                }
                    //                    }
            }
        }
    }
}

struct RegisterLayoutView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterLayoutView(title: "Welcome back! Glad to see you, Again!") {
            Text("Hello")
        }
        .environmentObject(AppConstants.shared)
            //            .environmentObject(AppConstants.shared)
            //            .environmentObject(ApiManager.shared)
    }
}
