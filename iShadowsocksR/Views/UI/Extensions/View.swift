//
//  view.swift
//  iShadowsocksR
//
//  Created by Tahir M. on 03/08/2023.
//  Copyright © 2023 DigitalD.Tech. All rights reserved.
//

import SwiftUI


extension View {
    func customForegroundStyle<Content: View>(_ content: Content) -> some View {
        self.overlay(content).mask(self)
    }
}
