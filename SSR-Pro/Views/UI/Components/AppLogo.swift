//
//  AppLogo.swift
//  VirgoVPN
//
//  Created by Tahir M. on 18/09/2023.
//

import SwiftUI
enum AppLogoVarient {
    case dark
    case light
}
struct AppLogo: View {
    @EnvironmentObject var appConstants: AppConstants
    var logoHeight: CGFloat = 40
    var fontSize: CGFloat = 28
    var variant: AppLogoVarient = .dark
    var body: some View {
        HStack(spacing: 3) {
            Image("SplashLogo")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: logoHeight)
            Text(appName1)
                .font(Font.logoFont(size: fontSize))
                .foregroundStyle(LinearGradient(gradient: Gradient(colors:  appConstants.gradientColors), startPoint: .leading, endPoint: .trailing))
            Text(appName2)
                .font(Font.logoFont(size: fontSize))
                .foregroundStyle(variant == .light ? Color.black : Color.white)
        }
    }
}

#Preview {
    AppLogo(logoHeight: 40, fontSize: 28)
        .environmentObject(AppConstants.shared)
}
