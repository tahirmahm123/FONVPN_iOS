//
//  LoginLayoutView.swift
//  VPN-Lightning
//
//  Created by Tahir M. on 05/07/2023.
//  Copyright © 2023 Onion Tech Ltd. All rights reserved.
//

import Foundation
import SwiftUI

struct LoginLayoutView<Content: View>: View {
    @EnvironmentObject var appConstants: AppConstants
    @EnvironmentObject var router: AppRouter
    @ViewBuilder var content: Content
    var title: String
    init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }
    var body: some View {
        BasicLayoutView(title: title) {
            VStack(spacing: 20) {
                content
                Button(action: {
                    
                }) {
                    Text("Forget Password?")
                        .font(Font.system(size: 16, weight: .semibold))
                        .foregroundColor(Color("AccentColor"))
                        .frame(height: 34, alignment: .center)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical)
            }
            Spacer()
            
            VStack( spacing: 20) {
                SocialLoginStackView()
                Spacer()
                HStack(alignment: .center) {
                    Spacer()
                    Text("Don't have an Account?")
                    Button(action: {
                        router.pushTo(view: ControllerHelper.registerEmailVC(nav: router.nav!))
                    }) {
                        Text("Create Account")
                            .foregroundColor(Color("AccentColor"))
                    }
                    Spacer()
                }
                    //                    }
            }
        }
    }
}

struct LoginLayoutView_Previews: PreviewProvider {
    static var previews: some View {
        LoginLayoutView(title: "Welcome back! Glad to see you, Again!") {
            Text("Hello")
        }
            .environmentObject(AppConstants.shared)
            //            .environmentObject(AppConstants.shared)
            //            .environmentObject(ApiManager.shared)
    }
}
