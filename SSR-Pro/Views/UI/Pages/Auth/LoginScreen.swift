//
//  Login.swift
//  VIS VPN
//
//  Created by Azhar's Macbook Pro on 25/06/2023.
//

import SwiftUI
//import QRScanner

struct LoginScreen: View {
    @EnvironmentObject var appConstants: AppConstants
    @EnvironmentObject var router: AppRouter
    @State var loginWithAccountID = false
    @State var signInWithEmail = false
    @State private var accountId = ""
    @State private var email = "testing007"
    @State private var password = "testing"
    @State private var showToast = false
    @State private var showActiveDevices = false
    @State private var errorShow = false
    @State private var errorMessage = ""
    let loginActionNotification = NotificationCenter.default
        .publisher(for: .LoginActionWithUrl)
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack {
                    VStack(alignment: .leading) {
                        HStack {
                            Text("Let's Get Started")
                                .font(Font.system(size: 32, weight: .semibold))
                            Spacer()
                        }
                        HStack {
                            Text("Secure Access Anywhere:")
                                .font(Font.system(size: 20, weight: .semibold))
                                .foregroundColor(.gray)
                            Spacer()
                        }
                        HStack {
                            Text("Sign in to VIS VPN")
                                .font(Font.system(size: 24, weight: .semibold))
                                .foregroundColor(.gray)
                            Spacer()
                        }
                    }
                    
                    GuestError(show: $errorShow, message: $errorMessage)
                    VStack(spacing: 20) {
                        if loginWithAccountID {
                            FloatingInput("Enter your Account ID", text: $email, secureInput: .constant(false))
                                .frame(height: 60)
                                .clipShape(RoundedRectangle(cornerRadius: 14))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 14)
                                        .stroke(Color(UIColor.lightGray), lineWidth: 1)
                                )
                        } else {
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
                            
                        }
                        Button(action: {
                            NotificationCenter.default.post(name: .LoginActionWithUrl, object: nil, userInfo: [
                                "token": nil
                            ]);
                        }) {
                            HStack{
                                Text("Sign in")
                            }
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .frame(height: 60)
                            .background(
                                LinearGradient(colors: [Color("SecondaryGradientColor1"), Color("SecondaryGradientColor2")], startPoint: .bottomLeading, endPoint: .topTrailing))
                            .cornerRadius(14)
                        }
                    }
                    .padding(.vertical)
                    if !loginWithAccountID {
                        Button(action: {
                            
                        }, label: {
                            Text("Forget Password?")
                                .foregroundColor(Color("AccentColor"))
                        })
                    }
                    Spacer()
                    VStack(spacing: 15) {
                        Text("OR")
                            .foregroundColor(Color("FadedColor"))
                        Button(action: {
                            loginWithAccountID.toggle()
                        }) {
                            if loginWithAccountID {
                                HStack {
                                    Image(systemName: "envelope")
                                    Text("Continue with Email")
                                        .font(.headline)
                                }
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color("FadedColor"))
                                .cornerRadius(10)
                            } else {
                                HStack {
                                    Image(systemName: "person.badge.key")
                                    Text("Continue with Account ID")
                                        .font(.headline)
                                }
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color("FadedColor"))
                                .cornerRadius(10)
                            }
                        }
//                        Button(action: {
//                            let vc = QRScannerController()
//                            vc.success = {code in
//                                router.pop()
//                                if code != nil {
//                                    print("Scanned QR with Data: \(code!)")
//                                }
//                            }
//                            router.pushTo(view: vc)
//                        }) {
//                            HStack{
//                                Image(systemName: "qrcode")
//                                Text("Continue with QR Code")
//                            }
//                            .font(.headline)                                .padding()
//                            .frame(maxWidth: .infinity)
//                            .background(Color("FadedColor"))
//                            .cornerRadius(10)
//                        }
//                        HStack {
//                            Text("New to VIS VPN?")
////                            Button(action: {
////                                
////                            }) {
//                            NavigationLink(destination: RegisterScreen()) {
//                                Text("Register")
//                                    .foregroundColor(Color("AccentColor"))
//                            }
//                        }
//                        
                        Button(action: {
                            
                        }) {
                            Text("Restore Purchase")
                                .foregroundColor(Color("AccentColor"))
                        }
                    }
                }
                .frame(minHeight: geometry.size.height)
                .padding(.horizontal)
                .onTapGesture {
                    UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.endEditing(true)
                }
                .sheet(isPresented: $showActiveDevices) {
                    ActiveDevicesView(onDismiss: {
                        
                    })
                }
            }
                //        }
                //        edgesIgnoringSafeArea(.)
//            .navigationBarItems(leading: Button(action: {
//                router.pop()
//            }) {
//                HStack(spacing: 0){
//                    Image(systemName: "chevron.left")
//                    Text("Back")
//                }
//            })
            
            
        }
        .toast(isPresenting: $showToast) {
            AlertToast(displayMode: .alert, type: .loading, title: "Logging in")
        }
        .navigationBarTitle("Sign in with \(loginWithAccountID ? "Account ID" : "Email")", displayMode: .inline)
        .onReceive(loginActionNotification) { (notification: Notification) in
            let token: String? = notification.userInfo?["token"] as? String;
            print(token ?? "");
            Thread.printCurrent()
            userDefaults.removeObject(forKey: urlAuthToken)
            self.login(token)
        }
    }
    
    func login(_ token: String? = nil) {
        $showToast.wrappedValue = true
        Task {
            if await InternetAvailability.shared.connectivityStatus() {
                let (auth, isLoginAllowed , isEmailActive, isExpired, isActive) = token == nil ? await ApiManager.shared.verifyUser(userName: email, password: password) : await ApiManager.shared.verifyUser(token: token ?? "")
                DispatchQueue.main.async {
                    Thread.printCurrent()
                    $showToast.wrappedValue = false
                    appConstants.refreshData()
                    if auth {
                            //                self.invalideCredentialsView.isHidden = true
                        if isActive{
                            if isLoginAllowed  && isEmailActive{
                                userDefaults.set(true, forKey: isLogedIn)
                                userDefaults.set(!isExpired, forKey: isPaidUser)
                                    //                                appConstants.generateKeys()
                                let vc = ControllerHelper.homeVC(nav: router.nav!)
                                router.setRoot(views: [vc])
                            } else if !isEmailActive {
                                    // to activate email if required
                            }else {
                                showActiveDevices.toggle()
                            }
                        } else {
                            self.error(true, message: "Your account is not active. Please contact support for further assistence.")
                        }
                    } else {
                        self.error(true, message: "The email or password you entered is incorrect. Please try again.")
                    }
                }
            }else {
                DispatchQueue.main.async {
                    $showToast.wrappedValue = false
                    self.error(true, message: "Please check your Internet Connection")
                }
            }
        }
    }
    
    
    func error(_ show: Bool, message: String) {
        errorMessage = message
        errorShow = show
    }
}

struct LoginScreen_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            LoginScreen()
        }
    }
}
