//
//  LoginView.swift
//  VPN-Lightning
//
//  Created by Tahir M. on 27/06/2023.
//  Copyright © 2023 Onion Tech Ltd. All rights reserved.
//

import SwiftUI

struct EmailLoginView: View {
    @EnvironmentObject var appConstants: AppConstants
    @EnvironmentObject var router: AppRouter
    
    @State private var showsAlert = false
    @State private var secureEntry = false
    @State private var errorShow = false
    @State private var errorMessage = ""
    @State private var text = ""
    @State private var showToast = false
    
    let showGuestLoader = NotificationCenter.default
        .publisher(for: .ShowGuestLoader)
    let showGuestError = NotificationCenter.default
        .publisher(for: .ShowGuestError)
    var body: some View {
        LoginLayoutView(title: "Welcome back! Glad to see you, Again!") {
            GuestError(show: $errorShow, message: $errorMessage)
            HStack {
                FloatingInput("Email/Username", text: $text, secureInput: $secureEntry)
                    .frame(height: 60)
                Image("EmailIcon").padding()
            }
            .background(Color(UIColor.systemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
            GradientButton(action: {
                errorShow = false
                errorMessage = ""
                if text.count > 0 {
                    UIApplication.shared.endEditing()
                    userDefaults.set(text, forKey: UserName)
                    router.pushTo(view: ControllerHelper.loginPasswordVC(nav: router.nav!))
                } else {
                    errorShow = true
                    errorMessage = "Please Enter Email/Username to Continue"
                }
            }) {
                Text("Continue")
                    .foregroundColor(Color.white)
            }
        }
        .toast(isPresenting: $showToast) {
            AlertToast(displayMode: .alert, type: .loading, title: "Logging in")
        }
        .onReceive(showGuestLoader) { (notification: Notification) in
            $showToast.wrappedValue = notification.userInfo!["state"] as! Bool
        }
        .onReceive(showGuestError) { (notification: Notification) in
            errorShow = notification.userInfo!["state"] as! Bool
            errorMessage = notification.userInfo!["message"] as! String
        }
    }
    
    func isValidEmail(email: String) -> Bool {
            // Create a regular expression pattern to match the email format
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        do {
                // Create a regular expression object using the emailRegex pattern
            let regex = try NSRegularExpression(pattern: emailRegex)
                // Check if the email matches the regular expression pattern
            let matches = regex.matches(in: email, range: NSRange(location: 0, length: email.count))
            return matches.count > 0
        } catch {
                // Handle any errors that occur when creating the regular expression object
            return false
        }
    }
    
}
struct EmailLoginView_Previews: PreviewProvider {
    static var previews: some View {
        EmailLoginView()
            .environmentObject(AppConstants.shared)
//            .environmentObject(AppConstants.shared)
//            .environmentObject(ApiManager.shared)
    }
}
