//
//  Warning.swift
//  VPN-Lightning
//
//  Created by Tahir M. on 07/07/2023.
//  Copyright © 2023 Onion Tech Ltd. All rights reserved.
//

import SwiftUI

struct Warning: View {
    var message: String
    @State private var show = true
    var body: some View {
        HStack {
            Image("WarningIcon")
            Text(message)
                .foregroundColor(Color("WarningForegroundColor"))
                .font(Font.custom("Urbanist", size: 14))
            Spacer()
            Button(action: {
                show.toggle()
            }) {
                Text("Close")
                    .foregroundColor(Color("WarningForegroundColor"))
                    .font(Font.custom("Urbanist", size: 14))
            }
                //                        .border(Color(Color("WarningForegroundColor")), width: 2)
        }
        .padding()
        .background(Color("WarningBackgroundColor"))
        .clipShape(RoundedRectangle(cornerRadius: 8.0, style: .circular))
    }
}


struct Warning_Previews: PreviewProvider {
    static var previews: some View {
        Warning(message: "Hello")
            .environmentObject(AppConstants())
    }
}

