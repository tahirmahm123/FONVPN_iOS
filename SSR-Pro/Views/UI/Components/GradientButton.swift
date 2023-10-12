//
//  GradientButton.swift
//  VPN-Lightning
//
//  Created by Tahir M. on 05/07/2023.
//  Copyright © 2023 Onion Tech Ltd. All rights reserved.
//

import Foundation
import SwiftUI

struct GradientButton<Content: View>: View {
    @ViewBuilder var content: Content
    var action: (() -> Void)
    @EnvironmentObject var appConstants: AppConstants
    @Environment(\.colorScheme) var colorScheme
    
    @Binding var disabled: Bool
    init(disabled: Binding<Bool> = .constant(false),action: @escaping (() -> Void), @ViewBuilder content: () -> Content) {
        self.action = action
        self.content = content()
        self._disabled = disabled
    }
    var body: some View {
        Button(action: action ) {
            content
        }
        .padding(.vertical)
        .foregroundColor(.white)
        .frame(maxWidth: .infinity)
        .background(AnyView(
            LinearGradient(gradient: Gradient(colors: colorScheme == .light ? appConstants.gradientColors : [appConstants.gradientColors[1]]), startPoint: .leading, endPoint: .trailing)
        ))
        .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
        .disabled(disabled)
    }
}

struct GradientButton_Previews: PreviewProvider {
    static var previews: some View {
        GradientButton(action: { }) {
            Text("Continue")
                .frame(height: 34, alignment: .center)
        }
        .environmentObject(AppConstants.shared)
    }
}
