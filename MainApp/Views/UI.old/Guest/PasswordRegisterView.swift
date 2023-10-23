//
//  RegisterPasswordView.swift
//  VPN-Lightning
//
//  Created by Tahir M. on 10/07/2023.
//  Copyright © 2023 Onion Tech Ltd. All rights reserved.
//
import Foundation
import SwiftUI

struct PasswordRegisterView: View {
    @EnvironmentObject var appConstants: AppConstants
    @EnvironmentObject var router: AppRouter
    
    @State private var showActiveDevices = false
    @State private var showToast = false
    @State private var text = ""
    @State private var secureEntry = true
    @State private var user = ""
    @State private var errorShow = false
    @State private var errorMessage = ""
    @State private var userIcon = ""
    
    @State private var allowRegister: Bool = false
    let showGuestLoader = NotificationCenter.default
        .publisher(for: .ShowGuestLoader)
    let showGuestError = NotificationCenter.default
        .publisher(for: .ShowGuestError)
    var body: some View {
        RegisterLayoutView(title: "Create your password", socialButtons: false) {
            HStack {
                Image(userIcon)
                Text(user)
                Spacer()
                Button(action: {
                    router.pop()
                }) {
                    Text("Change").underline()
                        .foregroundColor(Color("AccentColor"))
                        .font(Font.custom("Urbanist", size: 14))
                        .underline()
                }
                .padding(.horizontal, 4)
            }
            .padding(.vertical, 0)
            GuestError(show: $errorShow, message: $errorMessage)
            HStack {
                FloatingInput("Password", text: $text, secureInput: $secureEntry)
                    .frame(height: 60)
                Button(action: {
                    secureEntry.toggle()
                }) {
                    Image("Password\(secureEntry ? "Shown" : "Hidden")")
                }
                .padding()
            }
            .background(Color(UIColor.systemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
            PasswordValidation(text: $text, completion: { allowed in
                allowRegister = allowed
            })
            GradientButton(disabled: $allowRegister, action: {
                errorShow = false
                errorMessage = ""
                if text.count > 0 {
                    UIApplication.shared.endEditing()
                    self.register()
                } else {
                    self.error(true, message: "Please Enter Password to Register")
                }
            }) {
                Text("Register")
                    .foregroundColor(Color.white)
                    .font(Font.custom("Urbanist", size: 16).weight(.bold))
            }.disabled(showToast)
        }
        .onAppear(perform: {
            let userName = userDefaults.string(forKey: UserName) ?? ""
            $user.wrappedValue = userName
            $userIcon.wrappedValue = "\(self.isValidEmail(email: userName) ? "Message" : "User")Icon"
        }) 
        .sheet(isPresented: $showActiveDevices) {
            ActiveDevicesView(onDismiss: {
                showActiveDevices.toggle()
            }, onContinue: {
                userDefaults.setValue(true, forKey: isLogedIn)
//                router.setRoot(views: [LaunchController.vc() ])
            })
        }
        .toast(isPresenting: $showToast) {
            AlertToast(displayMode: .alert, type: .loading, title: "Processing")
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
    
    func register() {
        $showToast.wrappedValue = true
        InternetAvailability.shared.connectivityStatus(completion: { (InternetStatus) -> Void in
            if InternetStatus{
                ApiManager.shared.registerUser(email: user , password: text, completion: { (success, isLoginAllowed, errors) -> Void in
                    $showToast.wrappedValue = false
                    if success {
                        if let errors = errors {
                            if (errors.email != nil) {
                                self.error(true, message: errors.email?[0] ?? "")
                            }else if (errors.password != nil) {
                                self.error(true, message: errors.password?[0] ?? "")
                            }
                        } else if isLoginAllowed {
                            userDefaults.set(true, forKey: isLogedIn)
                            userDefaults.set(user, forKey: UserName)
                            userDefaults.set(text, forKey: Password)
                            userDefaults.set(true, forKey: AutoSelectFastServer)
                            router.setRoot(views: [LaunchController.vc()])
                        } else {
                                // for otp varifcation
                        }
                    } else {
                        self.error(true, message: "An error occured. Please try again.")
                    }
                })
            }else {
                $showToast.wrappedValue = false
                self.error(true, message: "Please check your Internet Connection")
            }
        })
    }
    
    func error(_ show: Bool, message: String) {
        errorMessage = message
        errorShow = show
    }
}
struct PasswordRegisterView_Previews: PreviewProvider {
    static var previews: some View {
        PasswordRegisterView()
            .environmentObject(AppConstants.shared)
    }
}
