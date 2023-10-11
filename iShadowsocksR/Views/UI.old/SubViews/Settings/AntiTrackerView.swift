//
//  AntiTrackerView.swift
//  VPN-Lightning
//
//  Created by Tahir M. on 28/05/2023.
//  Copyright © 2023 Onion Tech Ltd. All rights reserved.
//

import SwiftUI

struct AntiTrackerView: View {
    @Binding var antiTrackerEnabled: Bool
    @State private var showToast = false
    @State private var showReconnectSheet = false
    @State private var message: String = ""
    var onDismiss: (() -> Void)
    var body: some View {
        NavigationView  {
            List {
                Section(
                    header: Text("General Information"),
                    footer: Text("AntiTracker uses our private DNS to block ads, malicious website and third-party trackers such as Google Analytics.")
                ) {
                    Button(action: {
                        antiTrackerEnabled.toggle()
                    }) {
                        HStack {
                            Text("Enabled")
                                .foregroundColor(Color(UIColor.label))
                            Spacer()
                            Toggle("", isOn: $antiTrackerEnabled)
                        }
                    }
                }
            }
            .navigationBarTitle("Anti Tracker", displayMode: .inline)
            .navigationBarItems(leading: Button(action: {
                onDismiss()
            }) {
                Image(systemName: "xmark")
            })
            .onChange(of: antiTrackerEnabled) { newValue in
                if vpnStatus == .connected || vpnStatus == .connecting {
                    reconnectPopUp(confirmed: {
                        doChanges(value: newValue, reconnect: true)
                    })
                }else {
                    doChanges(value: newValue, reconnect: false)
                }
            }
            .actionSheet(isPresented: $showReconnectSheet) {
                ActionSheet(
                    title: Text("Reconnect VPN").font(Font.custom("Urbanist", size: 16.0)),
                    message: Text("To apply the new settings, \(appName) needs to be reconnected and this will override the custom DNS setting.").font(Font.custom("Urbanist", size: 13.0)),
                    buttons: [
                        .default(Text("Reconnect").font(Font.custom("Urbanist", size: 14.0)), action: {
                            doChanges(value: antiTrackerEnabled, reconnect: true)
                        }),
                        .default(Text("Reconnect + Don't ask next time").font(Font.custom("Urbanist", size: 14.0)), action: {
                            userDefaults.set(true, forKey: NotAskToReconnect)
                            doChanges(value: antiTrackerEnabled, reconnect: true)
                        }),
                        .cancel(Text("Cancel").font(Font.custom("Urbanist", size: 14.0)), action: {
                            showReconnectSheet = false
                            antiTrackerEnabled.toggle()
                        })
                    ]
                )
            }
            .toast(isPresenting: $showToast, duration: 2, tapToDismiss: true, alert: {
                AlertToast(displayMode: .banner(.pop), type: .regular, title: "Anti Tracker is \(antiTrackerEnabled ? "On" : "Off")")
            })
            .accentColor(Color("AccentColor"))
        }
    }
    
    func showToast(message: String) {
        $showToast.wrappedValue = true
        $message.wrappedValue = message
    }
    
    func reconnectPopUp(confirmed: @escaping (() -> Void)) {
        guard !userDefaults.bool(forKey: NotAskToReconnect) else {
            confirmed()
            return
        }
        $showReconnectSheet.wrappedValue = true
    }
    
    func doChanges(value: Bool, reconnect: Bool) {
        userDefaults.set(value, forKey: AntiTracker)
        userDefaults.set(!value, forKey: DnsEnabled)
        $antiTrackerEnabled.wrappedValue = value
        if reconnect {
            NotificationCenter.default.post(name: .ReconnectWithNewSettings, object: nil)
        }
        $showToast.wrappedValue = true
    }
}

struct AntiTrackerView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView() {
            @State var visible = false
            AntiTrackerView(antiTrackerEnabled: $visible, onDismiss: {
                
            })
        }
    }
}
