//
//  LocationsView.swift
//  VPN-Lightning
//
//  Created by Tahir M. on 12/06/2023.
//  Copyright © 2023 Onion Tech Ltd. All rights reserved.
//

import SwiftUI

struct LocationsView: View {
    @Binding var isShowing: Bool
    let items: [String] = ["Hello"]

    var body: some View {
        LocationsWrapperVC(onServerSelection: serverSelection)
        .navigationBarTitle("All Locations", displayMode: .large)
        .navigationBarItems(trailing: Button(action: {
            NotificationCenter.default.post(name: .StartSearching, object: nil)
        }, label: {
            Text("Search")
        }))
        .onAppear(perform: {
            
        })
    }
    
    func serverSelection() {
        NotificationCenter.default.post(name: .ServerSelected, object: nil)
        $isShowing.wrappedValue = false
    }
}

struct LocationsView_Previews: PreviewProvider {
    static var previews: some View {
        @State var tabSelection: Bool = true
        LocationsView(isShowing: $tabSelection)
    }
}
