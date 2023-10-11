//
//  AppSettingsView.swift
//  VPN-Lightning
//
//  Created by Tahir M. on 28/05/2023.
//  Copyright © 2023 Onion Tech Ltd. All rights reserved.
//

import SwiftUI

struct AppSettingsView: View {
    @State private var selectedAppearance: Int = 0
    @State private var isAppearanceVisible = false
    var body: some View {
        List {
            HStack {
                VStack(alignment: .leading) {
                    Text("Version: 1.0.0")
                        .font(Font.custom("Urbanist", size: 16.0))
//                    Text("Click to Update Version.")
//                        .font(Font.custom("Urbanist", size: 14.0))
//                        .foregroundColor(.gray)
                }
                Spacer()
//                Button(action: {
//                    
//                }, label: {
//                    Text("Update")
//                        .font(Font.custom("Urbanist", size: 16.0))
//                        .foregroundColor(Color("ThemeColor"))
//                })
            }
            .padding(.vertical, 4)
            Button(action: {
                isAppearanceVisible.toggle()
            }) {
                VStack(alignment: .leading) {
                    Text("App Appearance")
                        .font(Font.custom("Urbanist", size: 16.0))
                    Text(getApperanceName(selectedAppearance))
                        .font(Font.custom("Urbanist", size: 14.0))
                        .foregroundColor(.gray)
                }
                .padding(.vertical, 4)
            }
        }
        .onAppear(perform: {
            $selectedAppearance.wrappedValue = userDefaults.integer(forKey: SelectedApperance)
        })
        .navigationBarTitle("App Settings", displayMode: .large).actionSheet(isPresented: $isAppearanceVisible) {
            ActionSheet(title: Text("App Appearance").font(Font.custom("Urbanist", size: 16.0)), message: Text("Select any App Apearance to change.").font(Font.custom("Urbanist", size: 13.0)), buttons: [
                .default(Text("Follow System").font(Font.custom("Urbanist", size: 14.0)), action: {
                    selectedAppearance = 0
                    DisplayUtility.shared.updateDisplayMode(selectedAppearance)
                }),
                .default(Text("Dark").font(Font.custom("Urbanist", size: 14.0)), action: {
                    selectedAppearance = 2
                    DisplayUtility.shared.updateDisplayMode(selectedAppearance)
                }),
                .default(Text("Light").font(Font.custom("Urbanist", size: 14.0)), action: {
                    selectedAppearance = 1
                    DisplayUtility.shared.updateDisplayMode(selectedAppearance)
                }),
                .cancel(Text("Cancel").font(Font.custom("Urbanist", size: 14.0)), action: {
                    self.isAppearanceVisible.toggle()
                })
            ])
        }
    }
    
    func getApperanceName(_ type: Int) -> String {
//        if selectedAppearance == 2 {
//            userInterfaceStyle = .dark
//        } else if selectedAppearance == 1 {
//            userInterfaceStyle = .light
//        } else {
//            userInterfaceStyle = .unspecified
//        }
        if type == 2 {
            return "Dark"
        } else if type == 1 {
            return "Light"
        } else {
            return "Follow System"
        }
    }
}

struct AppSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            AppSettingsView()
        }
    }
}
