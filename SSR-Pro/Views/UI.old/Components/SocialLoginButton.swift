//
//  SocialLoginButton.swift
//  VPN-Lightning
//
//  Created by Tahir M. on 03/07/2023.
//  Copyright © 2023 Onion Tech Ltd. All rights reserved.
//

import SwiftUI

struct SocialLoginButton<Content: View>: View {
    @ViewBuilder var content: Content
    var action: (() -> Void)
    @EnvironmentObject var appConstants: AppConstants
    @Environment(\.colorScheme) var colorScheme
    init(action: @escaping (() -> Void),@ViewBuilder content: () -> Content) {
        self.action = action
        self.content = content()
    }
    var body: some View {
        Button(action: action) {
            content
        }
        .foregroundColor(Color(UIColor.label))
        .frame(maxWidth: .infinity)
        .background(Color(UIColor.systemBackground))
//        .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
        
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(colorScheme == .dark ? Color.white.opacity(0.75) : Color(UIColor.lightGray).opacity(0.75), lineWidth: 1)
        )
//        .border(colorScheme == .dark ? Color.white : Color(UIColor.lightGray), width: 2)
    }
}

struct SocialLoginButton_Previews: PreviewProvider {
    static var previews: some View {
        SocialLoginButton(action: { }) {
            Text("Continue")
                .frame(height: 34, alignment: .center)
        }
            .environmentObject(AppConstants.shared)
    }
}
