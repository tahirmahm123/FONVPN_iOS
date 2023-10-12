//
//  LoginPageControll.swift
//  VIS VPN
//
//  Created by Tahir M. on 28/06/2023.
//

import SwiftUI

struct LoginPageControl: View {
    var index: Int
    var images = [
        "LoginImage1",
        "LoginImage2",
        "LoginImage3"
    ]
    var title = [
        "Secure Your Online Browsing",
        "Unlock Streaming Content",
        "Power of Secure Encryption"
    ]
    var subTitle = [
        "Protect your data and access restricted content with VIS VPN. Experience fast, reliable, and secure browsing on all your devices.",
        "Seamlessly access geo-restricted streaming services and unlock a world of entertainment with VIS VPN.",
        "Safeguard your online activities and protect your sensitive data with our state-of-the-art encryption protocols."
    ]
    var body: some View {
        VStack{
            Image(images[index])
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: 301)
            Text(title[index])
                .font(Font.system(size: 38, weight: .semibold))
                .multilineTextAlignment(.center)
                .foregroundColor(Color.white)
            Text(subTitle[index])
                .multilineTextAlignment(.center)
                .padding(.horizontal)
                .foregroundColor(Color.white)
        }
        .background(Color.clear)
    }
}

struct LoginPageControl_Previews: PreviewProvider {
    static var previews: some View {
        LoginPageControl(index: 2)
    }
}
