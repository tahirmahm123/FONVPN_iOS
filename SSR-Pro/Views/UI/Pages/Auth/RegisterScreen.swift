//
//  LoginScreen.swift
//  VIS VPN
//
//  Created by Azhar's Macbook Pro on 25/06/2023.
//

import SwiftUI

struct RegisterScreen: View {
    @EnvironmentObject var appConstants: AppConstants
    @EnvironmentObject var router: AppRouter
    @State private var email = ""
    @State private var password = ""
    @State private var showToast = false
    @State private var showActiveDevices = false
    @State private var errorShow = false
    @State private var errorMessage = ""
    var body: some View {
        ScrollView {
            VStack {
                VStack(alignment: .leading) {
                    Text("Create Your Account for Enhanced Security")
                        //                .customForegroundStyle(LinearGradient(colors: [Color("PrimaryGradientColor1"), Color("PrimaryGradientColor2")], startPoint: .bottomTrailing, endPoint: .topLeading))
                        .font(Font.system(size: 31.5, weight: .semibold))
                        //            +
                }
                    //            .frame(width: UIScreen.main.bounds.width)
                
                GuestError(show: $errorShow, message: $errorMessage)
                VStack(spacing: 20) {
                    FloatingInput("Enter Email", text: $email, secureInput: .constant(false))
                        .frame(height: 60)
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                        .overlay(
                            RoundedRectangle(cornerRadius: 14)
                                .stroke(Color(UIColor.lightGray), lineWidth: 1)
                        )
                    FloatingInput("Enter Password", text: $password, secureInput: .constant(true))
                        .frame(height: 60)
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                        .overlay(
                            RoundedRectangle(cornerRadius: 14)
                                .stroke(Color(UIColor.lightGray), lineWidth: 1)
                        )
                    Button(action: {
                        if !email.isEmpty {
                            if email.isValidEmail() {
                                if !password.isEmpty {
                                    self.register()
                                } else {
                                    self.error(true, message: "Please Enter a valid Password")
                                }
                            }else {
                                self.error(true, message: "Please Enter a valid Email")
                            }
                        } else {
                            self.error(true, message: "Please Enter email to Continue")
                        }
                    }) {
                        HStack{
                            Image(systemName: "person.badge.plus")
                            Text("Create Account")
                        }
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .frame(height: 60)
                        .background(
                            LinearGradient(colors: [Color("PrimaryGradientColor1"), Color("PrimaryGradientColor2")], startPoint: .bottomLeading, endPoint: .topTrailing))
                        .cornerRadius(14)
                    }
                }
                .padding(.vertical)
                Text("By creating account, I accept Terms of Use and Privacy Policy.")
                    .multilineTextAlignment(.center)
                    .font(Font.system(size: 14, weight: .regular))
                Spacer()
                
                VStack(spacing: 10) {
//                    HStack {
//                        Text("Already Have an Account?")
//                        NavigationLink(destination: LoginScreen()) {
//                            Text("Sign in Here")
//                                .foregroundColor(Color("AccentColor"))
//                        }
//                    }
                    
                    Button(action: {
                        
                    }) {
                        Text("Restore Purchase")
                            .foregroundColor(Color("AccentColor"))
                    }
                }
            }
            .onTapGesture {
                UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.endEditing(true)
            }
        }
        .padding()
        .toast(isPresenting: $showToast) {
            AlertToast(displayMode: .alert, type: .loading, title: "Creating Account")
        }
        .navigationBarTitle("Create Account", displayMode: .inline)
    }
    
    
    func register() {
        $showToast.wrappedValue = true
        Task {
            if await InternetAvailability.shared.connectivityStatus() {
                let (success, isLoginAllowed, errors) = await ApiManager.shared.registerUser(email: email , password: password)
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
                        userDefaults.set(email, forKey: UserName)
                        userDefaults.set(password, forKey: Password)
                        userDefaults.set(true, forKey: AutoSelectFastServer)
                        router.setRoot(views: [SplashController.vc()])
                    } else {
                            // for otp varifcation
                    }
                } else {
                    self.error(true, message: "An error occured. Please try again.")
                }
            } else {
                $showToast.wrappedValue = false
                self.error(true, message: "Please check your Internet Connection")
            }
        }
    }
    
    func error(_ show: Bool, message: String) {
        errorMessage = message
        errorShow = show
    }
}

struct RegisterScreen_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            RegisterScreen()
                .environmentObject(AppRouter())
        }
    }
}
