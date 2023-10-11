//
//  ConnectionSettingsScreen.swift
//  VIS VPN
//
//  Created by Azhar's Macbook Pro on 25/06/2023.
//

import SwiftUI

struct ConnectionSettingsScreen: View {
    @State private var autoSwitchLocationToggle = false
    var body: some View {
        List{
            Section(header: Text("Connection Settings")) {
                Button(action: {
//                    deleteProfileShown.toggle()
                }) {
                    HStack{
                        VStack(alignment: .leading) {
                            Text("Auto Switch Location")
                                .foregroundColor(Color(UIColor.label))
                            Text("Auto Server Switch option in the background (in case of connectivity issue)")
                                .font(.subheadline)
                                .foregroundColor(Color("FadedColor"))
                            
                        }
//                        Spacer()
                        Toggle("", isOn: $autoSwitchLocationToggle)
                    }
                }
                Button(action: {
//                    deleteProfileShown.toggle()
                }) {
                    HStack{
                        Text("Auto Connect")
                            .foregroundColor(Color(UIColor.label))
//                        Spacer()
                        Toggle("", isOn: $autoSwitchLocationToggle)
                    }
                }
                VStack(alignment: .leading) {
                    Text("Report a issue")
                        .foregroundColor(Color(UIColor.label))
                    Text("Notify us of any problems you encounter in our app, and we'll promptly address and resolve them.")
                        .font(.subheadline)
                        .foregroundColor(Color("FadedColor"))
                    
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
        .listStyle(.plain)
        .navigationBarTitle("Connection Settings", displayMode: .large)
    }
}

struct ConnectionSettingsScreen_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ConnectionSettingsScreen()
        }
    }
}
