//
//  ChooseProtocolView.swift
//  VPN-Lightning
//
//  Created by Tahir M. on 27/05/2023.
//  Copyright © 2023 Onion Tech Ltd. All rights reserved.
//

import SwiftUI

struct ChooseProtocolView: View {
    @EnvironmentObject var app: AppConstants
    @State private var selectedProtocolAndPortOVPN = ""
    @State private var selectedProtocolAndPortWG = ""
    @State private var keyRotationTime = 0
    @State private var selectedProtocol: ProtocolType = .openvpn
    var onDismiss: (() -> Void)
    var selectedProtocolName: String {
        return availableProtocols[selectedProtocol]!
    }
//    var allPort = Avail
    var allProtocols: [ProtocolType] = [
        .openvpn, .wireguard
    ]
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("VPN Protocol")
                    .font(Font.system(size: 14))
                ) {
                    ForEach(allProtocols, id: \.self) { key in
                        Button(action: {
                            self.app.updateSelectedProtocol(key)
                            updatePorts(key)
                            selectedProtocol = key
                        }) {
                            HStack {
                                Image(selectedProtocol == key ? "SelectedRadioIcon" : "DeselectedRadioIcon")
                                    //                            if key == .automatic {
                                    //                                VStack(alignment: .leading) {
                                    //                                    Text(availableProtocols[key]!)
                                    //                                        .font(Font.system(size: 16))
                                    //                                    Text("Automatically select which protocol is best for you.")
                                    //                                        .font(Font.system(size: 12))
                                    //                                        .foregroundColor(.gray)
                                    //                                }
                                    //                            }else{
                                Text(availableProtocols[key]!)
                                    .font(Font.system(size: 16))
                                    //                            }
                            }
                        }
                        .padding(EdgeInsets(top: 6, leading: 0, bottom: 6, trailing: 0))
                        .foregroundColor(Color.primary)
                    }
                }
                Section(
                    header: Text("\(selectedProtocolName) Settings")
                        .font(Font.system(size: 14)),
                    footer: Text(selectedProtocolName == "Wireguard" ? "Keys rotation will start automatically in the defined interval. It will also change the interval IP address." : "")
                        .font(Font.system(size: 14))
                ) {
                    HStack{
                        Text("Protocol & Port")
                            .font(Font.system(size: 14))
                        Spacer()
                        if (selectedProtocol == .openvpn) {
                            Picker("", selection: $selectedProtocolAndPortOVPN) {
                                ForEach(0..<availableProtocolsAndPortOVPN.count, id: \.self) {
                                    Text(availableProtocolsAndPortOVPN[$0]).tag(availableProtocolsAndPortOVPN[$0])
                                }
                            }
                            .onChange(of: selectedProtocolAndPortOVPN) { newValue in
                                print("Selected option changed to: \(newValue)")
                                app.selectedPortAndProtocolOVPN = newValue
                            }
                        } else if selectedProtocol == .wireguard {
                            Picker("", selection: $selectedProtocolAndPortWG) {
                                ForEach(0..<availableProtocolsAndPortWG.count, id: \.self) {
                                    Text(availableProtocolsAndPortWG[$0]).tag(availableProtocolsAndPortWG[$0])
                                }
                            }
                            .font(Font.system(size: 14))
                            .onChange(of: selectedProtocolAndPortWG) { newValue in
                                print("Selected option changed to: \(newValue)")
                                app.selectedPortAndProtocolWG = newValue
                            }
                        }
                    }
                    .padding(EdgeInsets(top: 2, leading: 0, bottom: 2, trailing: 0))
                    if selectedProtocol == .wireguard {
                        HStack {
                            VStack(alignment: .leading) {
                                Text("Key Rotation")
                                    .font(Font.system(size: 14))
                                Text("Key rotate after every \(keyRotationTime) days")
                                    .font(Font.system(size: 12))
                                    .foregroundColor(.gray)
                            }
                            Stepper("", value: $keyRotationTime, in: 1...10)
                                .onChange(of: keyRotationTime) { newValue in
                                    print("Selected option changed to: \(newValue)")
                                    app.rotationDays = newValue
                                }
                        }
                        .padding(EdgeInsets(top: 6, leading: 0, bottom: 6, trailing: 0))
                        NavigationLink(destination: WireguardDetailsView()) {
                            Text("Wireguard Details")
                                .font(Font.system(size: 14))
                                .padding(EdgeInsets(top: 2, leading: 0, bottom: 2, trailing: 0))
                        }
                    }
                }
            }
            .navigationBarTitle("Choose Protocol", displayMode: .inline)
            .navigationBarItems(leading: Button(action: {
                onDismiss()
            }) {
                Image(systemName: "xmark")
            })
            .onAppear(perform: {
                keyRotationTime = app.rotationDays
                selectedProtocol = app.selectedProtocol
                updatePorts(selectedProtocol)
            })
            .accentColor(Color("AccentColor"))
        }
    }
    func updatePorts(_ type: ProtocolType) {
        selectedProtocolAndPortOVPN = app.selectedPortAndProtocolOVPN
        selectedProtocolAndPortWG = app.selectedPortAndProtocolWG
    }
    
}

struct ChooseProtocolView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ChooseProtocolView(onDismiss: {
                
            })
                .environmentObject(AppConstants())
        }
    }
}
