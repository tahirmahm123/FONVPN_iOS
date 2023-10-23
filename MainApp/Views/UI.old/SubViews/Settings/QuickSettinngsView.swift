//
//  QuickSettinngsView.swift
//  VPN-Lightning
//
//  Created by Tahir M. on 21/06/2023.
//  Copyright © 2023 Onion Tech Ltd. All rights reserved.
//

import SwiftUI

struct QuickSettinngsView: View {
    
    @Binding var visible: Bool
    @State private var servers: [ServerByCountry] = []
    var onDismiss: () -> Void
    var body: some View {
        NavigationView {
            List {
                ForEach(servers, id: \.flag) { country in
                    HStack {
                        Image(country.flag!)
                            .resizable()
                            .frame(width: 30, height: 30)
                            .clipShape(Circle())
                        Text(country.country!)
                        Spacer()
                    }
                    .onTapGesture {
                        let selectedProtocol = userDefaults.object(forKey: SelectedProtocol) as? ProtocolType ?? .openvpn
                        if selectedProtocol == .openvpn {
                            userDefaults.set(country.flag, forKey: QuickSettingsServerOVPN)
                        }else{
                            userDefaults.set(country.flag, forKey: QuickSettingsServerWG)
                        }
                        visible.toggle()
                        onDismiss()
                    }
                }
            }
//            .listRowInsets(.)
            .navigationBarTitle("Quick Connect", displayMode: .inline)
            .navigationBarItems(leading: Button(action: {
                visible.toggle()
                onDismiss()
            }) {
                Image(systemName: "xmark")
            })
            .onAppear(perform: {
                servers = serverData()!
            })
        }
        .accentColor(Color("ThemeColor"))
    }
    
    func serverData() -> [ServerByCountry]? {
        let selectedProtocol = userDefaults.object(forKey: SelectedProtocol) as? ProtocolType ?? .openvpn
        if selectedProtocol == .openvpn {
            return ApiManager.shared.groupedServersOVPN
        }else{
            return ApiManager.shared.groupedServersWG
        }
    }
}

struct QuickSettinngsView_Previews: PreviewProvider {
    static var previews: some View {
        @State var servers = false
        NavigationView {
            QuickSettinngsView(visible: $servers, onDismiss: {
                
            })
        }
    }
}
