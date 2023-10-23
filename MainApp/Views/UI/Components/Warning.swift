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
    var actionText: String = "Close"
    var action : (() -> Void)?
    @State private var show = true
    var body: some View {
        if show {
            HStack {
                Image("WarningIcon")
                Text(message)
                    .foregroundColor(Color("WarningForegroundColor"))
                    .font(Font.custom("Urbanist", size: 14))
                Spacer()
                Button(action: {
                    action?() ?? show.toggle()
                }) {
                    Text(actionText)
                        .foregroundColor(Color("WarningForegroundColor"))
                        .font(Font.custom("Urbanist", size: 14))
                        .padding(.horizontal)
                        .padding(.vertical, 5)
                }
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color("WarningForegroundColor"), lineWidth: 1)
                )
                    //                .border(Color("WarningForegroundColor"), width: 1)
            }
            .padding()
            .background(Color("WarningBackgroundColor"))
            .clipShape(RoundedRectangle(cornerRadius: 8.0, style: .circular))
        } else {
            EmptyView()
        }
    }
}


struct Warning_Previews: PreviewProvider {
    static var previews: some View {
        Warning(message: "Hello")
            .environmentObject(AppConstants())
    }
}

