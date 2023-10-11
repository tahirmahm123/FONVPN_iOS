
//
//  LoginView.swift
//  VPN-Lightning
//
//  Created by Tahir M. on 27/06/2023.
//  Copyright © 2023 Onion Tech Ltd. All rights reserved.
//

import SwiftUI

struct StoredEmailLoginView: View {
    @EnvironmentObject var appConstants: AppConstants
    @EnvironmentObject var router: AppRouter
    @State private var storedEmails: [EmailStoreModel] = []
    @State private var editMode = false
    init() {
            /// These could be anywhere before the list has loaded.
        UITableView.appearance().backgroundColor = .clear // tableview background
        UITableViewCell.appearance().backgroundColor = .clear // cell background
    }
    var body: some View {
        BasicLayoutView(title: "Choose an account to sign in with", scroll: false) {
            if storedEmails.count > 0 {
                ScrollView {
                    ForEach(storedEmails) { email in
                        HStack {
                            if editMode {
                                Image("Minus")
                                    .padding()
                            } else {
                                Image("StoredEmailIcon")
                                    .padding()
                            }
                            Text(email.email ?? "")
                                .font(Font.custom("Urbanist", size: 14).weight(.semibold))
                            Spacer()
                        }
                        .padding(2)
                        .frame(maxWidth: .infinity)
                        .background(Color(UIColor.systemBackground))
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        .onTapGesture(perform: {
                            if editMode {
                                EmailStoreManager.shared.removeFromCoreData(email.email!)
                                storedEmails = EmailStoreManager.shared.all() ?? []
                                
                            } else {
                                userDefaults.setValue(email.email, forKey: UserName)
                                router.pushTo(view: ControllerHelper.loginPasswordVC(nav: router.nav!))
                            }
                        })
                    }
                }
            } else {
                VStack{
                    HStack {
                        Spacer()
                        Text("No Accounts Found")
                            .foregroundColor(Color.secondary)
                            .font(Font.custom("Urbanist", size: 16))
                        Spacer()
                    }
                    .padding()
                }
            }
            
            Spacer()
            if editMode {
                HStack {
                    Spacer()
                    Text("Done")
                        .foregroundColor(Color("AccentColor"))
                        .font(Font.custom("Urbanist", size: 14))
                        .padding()
                    Spacer()
                }
                .padding(2)
                .frame(maxWidth: .infinity)
                .background(Color(UIColor.systemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .onTapGesture(perform: {
                    editMode.toggle()
                })
            } else {
                HStack {
                    Image("AddUser")
                        .padding()
                    Text("Add another account")
                        .font(Font.custom("Urbanist", size: 15))
                    Spacer()
                }
                .padding(2)
                .frame(maxWidth: .infinity)
                .background(Color(UIColor.systemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .onTapGesture(perform: {
                    router.pushTo(view: ControllerHelper.loginEmailVC(nav: router.nav!))
                })
                if storedEmails.count > 0 {
                    HStack {
                        Image("Minus")
                            .padding()
                        Text("Remove Account")
                            .font(Font.custom("Urbanist", size: 14))
                            .foregroundColor(Color("DangerColor"))
                        Spacer()
                    }
                    .padding(2)
                    .frame(maxWidth: .infinity)
                    .background(Color(UIColor.systemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .onTapGesture(perform: {
                        editMode.toggle()
                    })
                }
            }
        }
        .onAppear(perform: {
            storedEmails = EmailStoreManager.shared.all() ?? []
        })
    }
    
    
}
struct StoredEmailLoginView_Previews: PreviewProvider {
    static var previews: some View {
        StoredEmailLoginView()
            .environmentObject(AppConstants.shared)
            //            .environmentObject(AppConstants.shared)
            //            .environmentObject(ApiManager.shared)
    }
}
