//
//  AccountSettingsScreen.swift
//  VIS VPN
//
//  Created by Azhar's Macbook Pro on 25/06/2023.
//

import SwiftUI
import UIKit
enum ProfileAlertType {
    case logout
    case delete
}
struct AccountSettingsScreen: View {
    @EnvironmentObject var appConstants: AppConstants
    @EnvironmentObject var router: AppRouter
    @State private var showAlert = false
    @State private var showLoader = false
    @State private var showPayment = false
    @State private var selectedAlert: ProfileAlertType = .logout
    @State private var activeDeviceShown = false
    let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
    var body: some View {
        List{
            Section(header: Text("Account Details")) {
                VStack(alignment: .leading) {
                    Text("Email/Account ID")
//                        .foregroundColor(Color(UIColor.label))
                    Text(verbatim: appConstants.userName)
                        .font(.subheadline)
                        .foregroundColor(.gray)
//                        .foregroundColor(Color("FadedColor"))
                    
                }
                Button(action: {
                    activeDeviceShown.toggle()
                }) {
                    VStack(alignment: .leading) {
                        Text("Active Devices")
//                            .foregroundColor(Color(UIColor.label))
                        Text("\(appConstants.loggedInDevices) out of \(appConstants.totalDevicesAllowed) Devices")
                            .font(.subheadline)
                            .foregroundColor(.gray)
//                            .foregroundColor(Color("FadedColor"))
                        
                    }
                }
                HStack {
                    VStack(alignment: .leading) {
                        Text(appConstants.plan)
//                            .foregroundColor(Color(UIColor.label))
                        Text("Expies on \(appConstants.expiryDate)")
                            .font(.subheadline)
                            .foregroundColor(.gray)
//                            .foregroundColor(Color("FadedColor"))
                        
                    }
                    Spacer()
                    Button(action: {
                        showPayment.toggle()
                    }) {
                        Text("Upgrade")
                            .font(.subheadline)
//                            .foregroundColor(Color("FadedColor"))
                    }
                }
                Button(action: {
                    print("Logging out")
                    $selectedAlert.wrappedValue = .logout
                    showAlert.toggle()
                }) {
                    HStack {
                        Spacer()
                        Image(systemName: "arrow.left.to.line.compact")
                            .renderingMode(.template)
                            .foregroundColor(.red)
                        Text("Logout")
                            .foregroundColor(.red)
                            .font(.system(size: 13))
                            .padding(0)// Extend the tappable area to the entire button
                        Spacer()
                    }
                    .contentShape(Rectangle())
                }
                .listRowBackground(Color(red: 1.0, green: 0.8, blue: 0.8))
            }
            
            
            Section(header: Text("Account Settings")) {
                Button(action: {
                    $selectedAlert.wrappedValue = .delete
                    showAlert.toggle()
                }) {
                    VStack(alignment: .leading) {
                        Text("Delete Account")
                            .foregroundColor(Color.red)
                        Text("Permanently remove your all information from our system.")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        
                    }
                }
            }
            
            Section(header: Text("App Settings")) {
                if let version = version {
                    VStack(alignment: .leading) {
                        Text("Version")
                        Text("v\(version)")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                }
                if let lang = Locale.current.languageCode,
                   let langName = Locale.current.localizedString(forLanguageCode: lang),
                   let url = URL(string: UIApplication.openSettingsURLString),
                   UIApplication.shared.canOpenURL(url) {
                    Button(action: {
                        UIApplication.shared.open(url)
                    }) {
                        VStack(alignment: .leading) {
                            Text("Language")
                            Text(langName)
                                .font(.subheadline)
                                .foregroundColor(.gray)
                            
                        }
                    }
                }
            }
        }
//        .listStyle(.plain)
        .navigationBarTitle("Account Settings", displayMode: .large)
        .sheet(isPresented: $activeDeviceShown) {
            ActiveDevicesView(onDismiss: {
                activeDeviceShown.toggle()
            })
        }
        .compatibleFullScreen(isPresented: $showPayment) {
            PaymentScreen(onDismiss: {
                showPayment.toggle()
            })
        }
        .toast(isPresenting: $showLoader, alert: {
            AlertToast(type: .loading, title: (selectedAlert == .logout ? "Logging out" : "Deleting User"))
        })
        .alert(isPresented: $showAlert) {
            switch(selectedAlert) {
                case .delete:
                    Alert(
                        title: Text("Delete Confirmation"),
                        message: Text("Are you sure you want to delete? This action is permanent and cannot be undone."),
                        primaryButton: .destructive(Text("Confirm"), action: {
                            $showLoader.wrappedValue = true
                            self.delete()
                        }),
                        secondaryButton: .cancel(Text("Cancel").foregroundColor(Color("AccentColor")))
                    )
                case .logout:
                    Alert(title: Text("Logout User"),
                          message: Text("Are you sure you want to logout? Logging out will securely sign you out of your account and protect your privacy."),
                          primaryButton: .default(Text("Logout"), action: {
                        $showLoader.wrappedValue = true
                        Task {
                                //                    await vpn.uninstall()
                                //                    await vpn.disconnect()
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() , execute: {
                            self.logout()
                        })
                    }),
                          secondaryButton: .cancel(Text("Cancel")))
            }
            
        }
    }
    
    func logout() {
        appConstants.logout {
            $showLoader.wrappedValue = true
            router.setRoot(views: [ControllerHelper.getStartedVC(nav: router.nav!, login: true)])
        }
    }
    func delete() {
        appConstants.delete {
            $showLoader.wrappedValue = true
            router.setRoot(views: [ControllerHelper.getStartedVC(nav: router.nav!)])
        }
    }
}

struct AccountSettingsScreen_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            AccountSettingsScreen()
        }
    }
}
