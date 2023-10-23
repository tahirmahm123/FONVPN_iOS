//
//  ProfileView.swift
//  
//
//  Created by Tahir M. on 28/05/2023.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var appConstants: AppConstants
    @EnvironmentObject var router: AppRouter
    
    @State private var showLogoutSheet = false
    @State private var showLoader = false
    @State private var showPayment = false
    @State private var isActiveDevicesShown = false
    @State private var selectedLogoutAction: LogoutSheetAction? = nil
    var body: some View {
        NavigationView() {
            List {
                Section(header: Text("General Information")) {
                    HStack {
                        Image("AccountIcon")
                        VStack(alignment: .leading) {
                            Text("Email")
                                .font(Font.custom("Urbanist", size: 16.0))
                            Text(verbatim: appConstants.userName)
                                .font(Font.custom("Urbanist", size: 14.0))
                                .foregroundColor(.gray)
                        }
                        Spacer()
                        Button(action: {
                            showLogoutSheet = true
                        }, label: {
                            Text("Logout").font(Font.custom("Urbanist", size: 15.0))
                                .foregroundColor(.red)
                        })
                    }
                    .padding(.vertical, 4)
                    Button(action:  {
                        isActiveDevicesShown.toggle()
                    }) {
                        HStack {
                            Image("DevicesIcon")
                            VStack(alignment: .leading) {
                                Text("Active Devices")
                                    .font(Font.custom("Urbanist", size: 16.0))
                                    .foregroundColor(Color(UIColor.label))
                                Text("\(appConstants.loggedInDevices) out of \(appConstants.totalDevicesAllowed) Devices")
                                    .font(Font.custom("Urbanist", size: 14.0))
                                    .foregroundColor(.gray)
                            }
                        }
                        .padding(.vertical, 4)
                    }
                    HStack {
                        Image("SubscriptionIcon")
                        VStack(alignment: .leading) {
                            Text(appConstants.plan)
                                .font(Font.custom("Urbanist", size: 16.0))
                            Text("Expies on \(appConstants.expiryDate)")
                                .font(Font.custom("Urbanist", size: 14.0))
                                .foregroundColor(.gray)
                        }
                        Spacer()
                        Button(action: {
                            showPayment.toggle()
                        }, label: {
                            Text("Extend").font(Font.custom("Urbanist", size: 15.0))
                                .foregroundColor(Color("ThemeColor"))
                        })
                    }
                    .padding(.vertical, 4)
                }
                Section(header: Text("Help and Support")) {
                    NavigationLink(destination: GetHelpView()) {
                        HStack {
                            Image("HelpIcon")
                            VStack(alignment: .leading) {
                                Text("Get Help")
                                    .font(Font.custom("Urbanist", size: 16.0))
                                Text("Troubleshooting, Contact support, etc.")
                                    .font(Font.custom("Urbanist", size: 14.0))
                                    .foregroundColor(.gray)
                            }
                        }
                        .padding(.vertical, 4)
                    }
                }
                Section(header: Text("About App")) {
                    NavigationLink(destination: AppSettingsView()) {
                        HStack {
                            Image("AppSettingsIcon")
                            VStack(alignment: .leading) {
                                Text("App Settings")
                                    .font(Font.custom("Urbanist", size: 16.0))
                                Text("Version, Dark mode, etc.")
                                    .font(Font.custom("Urbanist", size: 14.0))
                                    .foregroundColor(.gray)
                            }
                        }
                        .padding(.vertical, 4)
                    }
                }
            }
            .onAppear(perform: {
                
            })
            .navigationBarTitle("Profile", displayMode: .large)
            .background(Color("TableBgColor").edgesIgnoringSafeArea(.all))
            .sheet(isPresented: $isActiveDevicesShown) {
                ActiveDevicesView(onDismiss: {
                    $isActiveDevicesShown.wrappedValue = false
                })
            }
            .actionSheet(isPresented: $showLogoutSheet) {
                ActionSheet(title: Text("Logout User").font(Font.custom("Urbanist", size: 16.0)), message: Text("Are you sure You want to Logout? ").font(Font.custom("Urbanist", size: 13.0)), buttons: [
                    .default(Text("Logout").font(Font.custom("Urbanist", size: 14.0)), action: {
                        $showLoader.wrappedValue = true
                        Task {
                            await vpn.uninstall()
                            await vpn.disconnect()
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() , execute: {
                            self.logout()
                        })
                    }),
                    .default(Text("Remember Me & Logout").font(Font.custom("Urbanist", size: 14.0)), action: {
                        $showLoader.wrappedValue = true
                        Task {
                            await vpn.uninstall()
                            await vpn.disconnect()
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() , execute: {
                            if let email = userDefaults.string(forKey: UserName) {
                                EmailStoreManager.shared.setInCoreData(email)
                            }
                            self.logout()
                        })
                    }),
                    .default(Text("Logout & Reset Defaults").font(Font.custom("Urbanist", size: 14.0)), action: {
                        $showLoader.wrappedValue = true
                        Task {
                            await vpn.uninstall()
                            await vpn.disconnect()
                        }
                        appConstants.resetDefaults()
                        DispatchQueue.main.asyncAfter(deadline: .now() , execute: {
                            self.logout()
                        })
                    }),
                    .cancel(Text("Cancel").font(Font.custom("Urbanist", size: 14.0)), action: {
                        showLogoutSheet = false
                    })
                ])
            }
            .toast(isPresenting: $showLoader, alert: {
                AlertToast(type: .loading, title: "Logging Out")
            })
            .compatibleFullScreen(isPresented: $showPayment) {
                PaymentScreen(onDismiss: {
                    showPayment.toggle()
                })
            }
        }.background(Color("BackgroundColor").edgesIgnoringSafeArea(.all))
    }
    
    func logout() {
        appConstants.logout {
            $showLoader.wrappedValue = true
            router.setRoot(views: [GetStartedController.vc()])
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
            .environmentObject(AppConstants())
            .environmentObject(AppRouter())
    }
}
