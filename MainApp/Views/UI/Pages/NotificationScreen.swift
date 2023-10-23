//
//  NotificationScreen.swift
//  VIS VPN
//
//  Created by Azhar's Macbook Pro on 25/06/2023.
//

import SwiftUI

struct NotificationScreen: View {
    @State private var detailsShown = false
    var body: some View {
        List{
            Section(header: Text("All Notifications")) {
                ForEach(0...3, id: \.self) {_ in
                    Button(action: {
                        detailsShown.toggle()
                    }) {
                        VStack(alignment: .leading) {
                            Text("Important Notice")
                                .foregroundColor(Color(UIColor.label))
                            Text("Today 12:00 AM")
                                .font(.subheadline)
                                .foregroundColor(Color("FadedColor"))
                            
                        }
                    }
                }
            }
        }
        .listStyle(.plain)
        .navigationBarTitle("Notification", displayMode: .large)
        .sheet(isPresented: $detailsShown) {
            NotificationDetailsScreen(onDismiss: {
                detailsShown.toggle()
            })
        }
    }
}

struct NotificationScreen_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView{
            NotificationScreen()
        }
    }
}
