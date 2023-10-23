//
//  GetHelpView.swift
//  VPN-Lightning
//
//  Created by Tahir M. on 28/05/2023.
//  Copyright © 2023 Onion Tech Ltd. All rights reserved.
//

import SwiftUI

struct GetHelpView: View {
    @State private var showResetProfile = false
    var body: some View {
        List {
            Section(header: Text("Troubleshoot")) {
                Button(action: {
                    showResetProfile.toggle()
                }) {
                    VStack(alignment: .leading) {
                        Text("Reset VPN Profile")
                            .font(Font.custom("Urbanist", size: 16.0))
                            .foregroundColor(Color(UIColor.label))
                        Text("Try if you're having connection issues.")
                            .font(Font.custom("Urbanist", size: 14.0))
                            .foregroundColor(.gray)
                    }
                    .padding(.vertical, 4)
                }
                NavigationLink(destination: Text("ActiveDevices")) {
                    VStack(alignment: .leading) {
                        Text("Report a bug")
                            .font(Font.custom("Urbanist", size: 16.0))
                        Text("Found an issue in our app? Let us know and we'll get it fixed.")
                            .font(Font.custom("Urbanist", size: 14.0))
                            .foregroundColor(.gray)
                    }
                    .padding(.vertical, 4)
                }
            }
            Section(header: Text("Customer support")) {
                Button(action: {
//                    ZohoSalesIQ.Chat.show()
                }) {
                    VStack(alignment: .leading) {
                        Text("Live Chat")
                            .font(Font.custom("Urbanist", size: 16.0))
                            .foregroundColor(Color(UIColor.label))
                        Text("Contact to our support team and chat now.")
                            .font(Font.custom("Urbanist", size: 14.0))
                            .foregroundColor(.gray)
                    }
                    .padding(.vertical, 4)
                }
            }
            Section(header: Text("General Info")) {
                Button(action: {
                    if let url = URL(string: PrivacyPolicyURL) {
                        if UIApplication.shared.canOpenURL(url) {
                            UIApplication.shared.open(url)
                        }
                    }
                }) {
                    Text("Privacy Policy")
                        .font(Font.custom("Urbanist", size: 16.0))
                        .padding(.vertical, 4)
                        .foregroundColor(Color(UIColor.label))
                }
                Button(action: {
                    if let url = URL(string: AcceptTermsURL) {
                        if UIApplication.shared.canOpenURL(url) {
                            UIApplication.shared.open(url)
                        }
                    }
                }) {
                    Text("Terms of service")
                        .font(Font.custom("Urbanist", size: 16.0))
                        .padding(.vertical, 4)
                        .foregroundColor(Color(UIColor.label))
                }
            }
        }
        .alert(isPresented: $showResetProfile) {
            Alert(
                title: Text("Reset VPN Profile"),
                message: Text("You'll be asked to reinstall the VPN profile on your next connection."),
                primaryButton: .destructive(Text("Continue"), action: {
                    Task {
                        await vpn.uninstall()
                        await vpn.disconnect()
                    }
                }),
                secondaryButton: .cancel()
            )
        }
        .navigationBarTitle("Get Help", displayMode: .large)
        .onAppear(perform: {
            UITableView.appearance().bounces = true
        })
    }
    private func sendLogs() {
        
//        
//        let composer = MFMailComposeViewController()
//        composer.mailComposeDelegate = self
//        composer.setToRecipients([Config.contactSupportMail])
//        
//        var openvpnLogAttached = false
//        var presentMailComposer = true
//        
//        
//        
//            // OpenVPN tunnel logs
//        Application.shared.connectionManager.getOpenVPNLog { openVPNLog in
//            if  userDefaults.bool(forKey: DiagnosticLogs) {
//                FileSystemManager.updateLogFile(newestLog: openVPNLog, name: Config.openVPNLogFile, isLoggedIn: Application.shared.authentication.isLoggedIn)
//                
//                let logFile = FileSystemManager.sharedFilePath(name: Config.openVPNLogFile).path
//                if let fileData = NSData(contentsOfFile: logFile), !openvpnLogAttached {
//                    composer.addAttachmentData(fileData as Data, mimeType: "text/txt", fileName: "\(Date.logFileName(prefix: "openvpn-")).txt")
//                    openvpnLogAttached = true
//                }
//            }
//            
//            if presentMailComposer {
//                self.present(composer, animated: true, completion: nil)
//                presentMailComposer = false
//            }
//        }
    }
}

struct GetHelpView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView() {
            GetHelpView()
        }
    }
}
