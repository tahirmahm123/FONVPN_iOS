//
//  LocationHeader.swift
//  VPN-Lightning
//
//  Created by Tahir M. on 13/06/2023.
//  Copyright © 2023 Onion Tech Ltd. All rights reserved.
//

import SwiftUI

struct LocationHeader: View {
//    @State var title: String
    
    var body: some View {
//        Button(action: {
//            withAnimation {
////                isOn.toggle()
//            }
//        }, label: {
            HStack{
                Image("de")
                    .resizable()
                    .frame(width: 30, height: 30)
                    .clipShape(Circle())
                VStack(alignment: .leading) {
                    Text("Germany")
                    Text("2 Locations")
                }
                Spacer()
                Image("arrow-down")
                    .resizable()
                    .frame(width: 20, height: 20)
                
            }
//        })
        .font(Font.caption)
        .background(Color(UIColor.systemBackground))
//        .foregroundColor(.accentColor)
        .frame(maxWidth: .infinity, alignment: .trailing)
//        .overlay(
//            Text(title),
//            alignment: .leading
//        )
    }
}
struct LocationHeader_Previews: PreviewProvider {
    static var previews: some View {
        @State var showSection = true
        LocationHeader()
    }
}
