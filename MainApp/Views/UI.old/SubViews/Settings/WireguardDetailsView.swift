//
//  WireguardDetailsView.swift
//  VPN-Lightning
//
//  Created by Tahir M. on 28/05/2023.
//  Copyright © 2023 Onion Tech Ltd. All rights reserved.
//

import SwiftUI

struct WireguardDetailsView: View {
    @EnvironmentObject var appConstants: AppConstants
    @State private var showToast = false
    @State private var toastMessage = ""
    var nextGenerationAt = "2022-10-03"
    var body: some View {
        List {
            HStack {
                VStack(alignment: .leading) {
                    Text("Public Key")
                        .font(Font.custom("Urbanist", size: 16.0))
                    Text(appConstants.publicKey)
                        .font(Font.custom("Urbanist", size: 14.0))
                        .foregroundColor(.gray)
                }
                Spacer()
                Button(action: {
                    $toastMessage.wrappedValue = "Public Key copied to Clipboard"
                    UIPasteboard.general.string = appConstants.publicKey
                    showToast.toggle()
                }, label: {
                    Image("clipboard-text")
                })
            }
            HStack {
                VStack(alignment: .leading) {
                    Text("Local IP")
                        .font(Font.custom("Urbanist", size: 16.0))
                    Text(appConstants.localIp)
                        .font(Font.custom("Urbanist", size: 14.0))
                        .foregroundColor(.gray)
                }
                Spacer()
                Button(action: {
                    $toastMessage.wrappedValue = "Local IP copied to Clipboard"
                    UIPasteboard.general.string = appConstants.localIp
                    showToast.toggle()
                }, label: {
                    Image("clipboard-text")
                })
            }
            VStack(alignment: .leading) {
                Text("Generated At")
                    .font(Font.custom("Urbanist", size: 16.0))
                Text(appConstants.keyGeneratedDate.formatDate())
                    .font(Font.custom("Urbanist", size: 14.0))
                    .foregroundColor(.gray)
            }
            VStack(alignment: .leading) {
                Text("Will rotated automatically")
                    .font(Font.custom("Urbanist", size: 16.0))
                Text(appConstants.nextGenerationDate.formatDate())
                    .font(Font.custom("Urbanist", size: 14.0))
                    .foregroundColor(.gray)
            }

        }
        .navigationBarTitle("Wiregurad Details", displayMode: .inline)
        .toast(isPresenting: $showToast, duration: 1, tapToDismiss: true, alert: {
            AlertToast(displayMode: .banner(.pop), type: .regular, title: toastMessage)
        })
    }
}

struct WireguardDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            WireguardDetailsView()
                .environmentObject(AppConstants())
        }
    }
}
