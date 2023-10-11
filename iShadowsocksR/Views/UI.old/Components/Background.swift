//
//  Background.swift
//  VPN-Lightning
//
//  Created by Tahir M. on 03/07/2023.
//  Copyright © 2023 Onion Tech Ltd. All rights reserved.
//

import SwiftUI

struct Background<Content: View>: View {
    private var content: Content
    var color: Color
    init(color: Color, @ViewBuilder content: @escaping () -> Content) {
        self.content = content()
        self.color = color
    }
    
    var body: some View {
        ZStack {
            color
//                .frame(height: .infinity)
                .edgesIgnoringSafeArea(.all)
            content
        }
        .background(color)
    }
}
