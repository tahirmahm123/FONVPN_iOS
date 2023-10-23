//
//  SupportCenterView.swift
//  VIS VPN
//
//  Created by Azhar's Macbook Pro on 25/06/2023.
//

import SwiftUI
import MessageUI
import NetworkExtension

struct SupportCenterView: View {
    @EnvironmentObject var router: AppRouter
    @State private var deleteProfileShown = false
    let mailDelegate =  MailDelegate()
    var body: some View {
        List{
            Section(header: Text("Troubleshooting")) {
                Button(action: {
                    deleteProfileShown.toggle()
                }) {
                    VStack(alignment: .leading) {
                        Text("Reset VPN Profile")
                            .foregroundColor(Color(UIColor.label))
                        Text("Resolve connectivity problems.")
                            .font(.subheadline)
                            .foregroundColor(Color("FadedColor"))
                        
                    }
                }
                Button(action: {
                    sendLogs()
                }) {
                    VStack(alignment: .leading) {
                        Text("Report a issue")
                            .foregroundColor(Color(UIColor.label))
                        Text("Notify us of any problems you encounter in our app, and we'll promptly address and resolve them.")
                            .font(.subheadline)
                            .foregroundColor(Color("FadedColor"))
                        
                    }
                }
            }
            Section(header: Text("Account Settings")) {
                Button(action: {
                    
                }) {
                    Text("Privacy Policy")
                        .foregroundColor(Color(UIColor.label))
                }
                Button(action: {
                    
                }) {
                    Text("Terms of services")
                        .foregroundColor(Color(UIColor.label))
                }
            }
        }
        .navigationBarTitle("Support Center", displayMode: .large)
//        .listStyle(.plain)
        .alert(isPresented: $deleteProfileShown) {
            Alert(
                title: Text("Reset VPN profile"),
                message: Text("You'll be asked to reinstall the VPN profile on your next connection."),
                primaryButton: .destructive(Text("Delete"), action: {
//                    Task {
                        let vpnManager = NETunnelProviderManager.shared()
                            // Remove the VPN configuration
                        vpnManager.removeFromPreferences { error in
                            if let error = error {
                                print("Error removing VPN configuration: \(error)")
                            } else {
                                print("VPN configuration removed successfully")
                            }
                        }
//                    }
                }),
                secondaryButton: .cancel(Text("Cancel").foregroundColor(Color("AccentColor")))
            )
        }
    }
    
    
    private func sendLogs() {
        let composer = MFMailComposeViewController()
        composer.mailComposeDelegate = mailDelegate
        composer.setToRecipients([supportEmail])
        
        var openvpnLogAttached = false
        var presentMailComposer = true
        
        
//        if  userDefaults.bool(forKey: DiagnosticLogs) {
//            FileSystemManager.updateLogFile(newestLog: logs, name: Config.openVPNLogFile, isLoggedIn: userDefaults.bool(forKey: isLogedIn))
//            
//            let logFile = FileSystemManager.sharedFilePath(name: Config.openVPNLogFile).path
//            if let fileData = NSData(contentsOfFile: logFile), !openvpnLogAttached {
//                composer.addAttachmentData(fileData as Data, mimeType: "text/txt", fileName: "\(Date.logFileName(prefix: "openvpn-")).txt")
//                openvpnLogAttached = true
//            }
//        }
        
        if presentMailComposer {
            router.presentVC(view: composer)
            presentMailComposer = false
        }
    }
}

class MailDelegate: NSObject,  MFMailComposeViewControllerDelegate {
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
}


struct SupportCenterView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SupportCenterView()
        }
    }
}
