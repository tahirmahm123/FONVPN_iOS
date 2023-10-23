//
//  GuestError.swift
//  VPN-Lightning
//
//  Created by Tahir M. on 06/07/2023.
//  Copyright © 2023 Onion Tech Ltd. All rights reserved.
//

import SwiftUI

struct GuestError: View {
    @Binding var show: Bool
    @Binding var message: String
    var body: some View {
        if show {
            HStack {
                Image(systemName: "exclamationmark.circle")
                    .resizable()
                    .renderingMode(.template)
                    .foregroundColor(.red)
                    .frame(width: 20, height: 20)
                Text(message)
                    .foregroundColor(Color.red)
                    .multilineTextAlignment(.leading)
                    .font(Font.system(size: 12))
                    .lineLimit(2)
                    .fixedSize(horizontal: false, vertical: true)
                Spacer()
            }
//            .frame(maxWidth: .infinity)
//            .padding()
//            .background(Color("ErrorBackgroundColor"))
//            .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
            
        }else {
            EmptyView()
        }
    }
}


struct GuestError_Previews: PreviewProvider {
    static var previews: some View {
        @State var show = true
        @State var message = "The email or password you entered is incorrect. Please try again."
        GuestError(show: $show, message: $message)
    }
}
