//
//  ConnectingStateButton.swift
//  VPN-Lightning
//
//  Created by Tahir M. on 31/05/2023.
//  Copyright © 2023 Onion Tech Ltd. All rights reserved.
//

import SwiftUI

struct ConnectingStateButton: View {
    @EnvironmentObject var appConstants: AppConstants
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        ZStack {
            AnimationView(name: "Loader",animationSpeed: 1,contentMode: .scaleAspectFit, play: .constant(true))
                .padding(5)
            LinearGradient(gradient: Gradient(colors: colorScheme == .light ? appConstants.gradientColors : [appConstants.gradientColors[1]]), startPoint: .leading, endPoint: .trailing)
                .mask(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(lineWidth: 2)
                )
                .padding(1)
        }
    }
}

struct ConnectingStateButton_Previews: PreviewProvider {
    static var previews: some View {
        ConnectingStateButton()
            .environmentObject(AppConstants())
    }
}
