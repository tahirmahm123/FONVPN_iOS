//
//  ActiveDevicesView.swift
//  VIS VPN
//
//  Created by Azhar's Macbook Pro on 25/06/2023.
//

import SwiftUI

struct ActiveDevicesView: View {
    @EnvironmentObject var appConstants: AppConstants
        //    @State var activeDevices: [ActiveSessions] = []
    @State private var showToast = false
    @State private var showLogoutSheet = false
    @State private var allDevices = false
    @State private var deviceName = ""
    @State private var deviceId = 0
    @State private var showLoader = false
    @State private var currentDevice = false
    var onDismiss: (() -> Void)?
    @State var onContinue: (() -> Void)?
    var body: some View {
        NavigationView {
            VStack{
                List {
                    ForEach(appConstants.activeDevices, id: \.id) { device in
//                        HStack {
                                //                        VStack(alignment: .leading) {
                                //                            Text("Macbook Air")
                                //                                .foregroundColor(Color(UIColor.label))
                                //                            Text("Last active: 2 minutes")
                                //                                .font(.subheadline)
                                //                                .foregroundColor(Color("FadedColor"))
                                //
                                //                        }
                                //                        Spacer()
                                //                        Button(action: {
                                //                            showLogoutSheet.toggle()
                                //                        }) {
                                //                            Image(systemName: "xmark")
                                //                        }
                                //                    }
                        HStack{
//                            Image("\(device.details!.type?.lowercased() ?? "ios")DeviceIcon")
//                                .resizable()
//                                .frame(width: 30, height: 30)
                            VStack(alignment: .leading, spacing: 2) {
                                Text(device.details!.name!)
                                    .fontWeight(.semibold)
                                    .foregroundColor(Color(UIColor.label))
                                if device.currentSession! {
                                    Text("Current Device")
                                        .font(Font.system(size: 13))
                                        .fontWeight(.regular)
                                        .opacity(0.5)
                                }else {
                                    Text(device._last_used_at!)
                                        .font(Font.system(size: 13))
                                        .fontWeight(.regular)
                                        .opacity(0.5)
                                }
                                
                            }
                            Spacer()
                            if !(device.currentSession ?? false) {
                                Button(action: {
                                    $deviceId.wrappedValue = device.tokenId!
                                    $allDevices.wrappedValue = false
                                    $deviceName.wrappedValue = device.details!.name!
                                    showLogoutSheet.toggle()
                                }){
                                    Image(systemName: "xmark")
                                }
                            }
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                }
                .listStyle(.plain)
                if !appConstants.loggedIn && appConstants.currentDevice {
                    Spacer()
                    Button(action: {
                        onContinue?()
                    }) {
                        Text("Continue")
                    }
                }
            }
            .navigationBarTitle("Active Devices", displayMode: .inline)
            .navigationBarItems(trailing: Button(action: {
                $allDevices.wrappedValue = true
                showLogoutSheet.toggle()
            }) {
                Text("Logout All")
            })
            .navigationBarItems(leading: Button(action: {
                onDismiss?()
            }) {
                Image(systemName: "xmark")
            })
            
        }
        .onAppear(perform:  {
            appConstants.updateUserDetails()
        })
        .actionSheet(isPresented: $showLogoutSheet) {
            ActionSheet(
                title: Text("Logout Device"),
                message: Text("Are you sure you want to logout \(allDevices ? "All Devices" : "\"\(deviceName)\"" )? "),
                buttons: [
                    .default(Text("Yes"), action: {
                        $showLoader.wrappedValue = true
                        if allDevices {
                            appConstants.logoutAllDevices {
                                $showLoader.wrappedValue = false
                                $showToast.wrappedValue = true
                            }
                        } else {
                            appConstants.logoutDevice(deviceId, completion: {
                                $showLoader.wrappedValue = false
                                $showToast.wrappedValue = true
                            })
                        }
                    }),
                    .cancel(Text("No"), action: {
                        showLogoutSheet = false
                    })
                ]
            )
        }
        .toast(isPresenting: $showToast, duration: 2, tapToDismiss: true, alert: {
            AlertToast(displayMode: .banner(.pop), type: .regular, title: "\(allDevices ? "All Devices":"\"\(deviceName)\"") logged out Successfully.")
        })
        .toast(isPresenting: $showLoader, alert: {
            AlertToast(type: .loading, title: "Please wait")
        })
        .accentColor(Color("AccentColor"))
    }
}

struct ActiveDevicesView_Previews: PreviewProvider {
    static var previews: some View {
        ActiveDevicesView(onDismiss: {
            
        })
    }
}
