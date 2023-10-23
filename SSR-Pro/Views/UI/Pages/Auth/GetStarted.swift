//
//  GetStarted.swift
//  VIS VPN
//
//  Created by Azhar's Macbook Pro on 25/06/2023.
//

import SwiftUI

struct GetStarted: View {
    @EnvironmentObject var router: AppRouter
    let timer = Timer.publish(every: 4, on: .main, in: RunLoop.Mode.common).autoconnect()
    @State var showLogin = false
    var body: some View {
        NavigationView {
            VStack{
                AppLogo(logoHeight: 42, fontSize: 22, variant: .dark)
                    .padding(.top)
                PageViewControl()
                    .frame(height: UIScreen.main.bounds.height*0.65)
//                Button(action: {
//                    router.pushTo(view: ControllerHelper.registerVC(nav: router.nav!))
//                }) {
                NavigationLink(destination: RegisterScreen()) {
                    Text("Let's Get Started")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color("AccentColor"))
                        .cornerRadius(14)
                }
                .isDetailLink(false)
                .padding(.horizontal)
                Spacer()
                
                HStack {
                    Text("Already Have an Account?")
                        .foregroundColor(Color.white)
//                    Button(action: {
//                        router.pushTo(view: ControllerHelper.loginVC(nav: router.nav!))
//                    }) {
//                    
                    NavigationLink(destination: LoginScreen(loginWithAccountID: false), isActive: $showLogin) {
                        Text("Sign in Here")
                            .foregroundColor(Color("AccentColor"))
                    }
                    .isDetailLink(false)
                }
                Spacer()
                HStack {
                    Button(action: {
                        
                    }) {
                        Text("Privacy Policy")
                            .foregroundColor(Color("AccentColor"))
                            .font(Font.system(size: 12))
                    }
                    Spacer()
                    Button(action: {
                        
                    }) {
                        Text("Terms of Service")
                            .foregroundColor(Color("AccentColor"))
                            .font(Font.system(size: 12))
                    }
                    Spacer()
                    Button(action: {
                        
                    }) {
                        Text("Restore Purchase")
                            .foregroundColor(Color("AccentColor"))
                            .font(Font.system(size: 12))
                    }
                }
                .padding(.horizontal)
            }
            .background(ZStack {
                LinearGradient(colors: [Color("BackgroundGradientColor1"), Color("BackgroundGradientColor2")], startPoint: .leading, endPoint: .trailing)
                Image("Background")
            })
        }
    }
}

struct GetStarted_Previews: PreviewProvider {
    static var previews: some View {
        GetStarted()
            .environmentObject(AppRouter())
    }
}
