//
//  BasicLayout.swift
//  VPN-Lightning
//
//  Created by Tahir M. on 07/07/2023.
//  Copyright © 2023 Onion Tech Ltd. All rights reserved.
//

import Foundation
import SwiftUI

struct BasicLayoutView<Content: View>: View {
    @ViewBuilder var content: Content
    var title: String
    var scroll: Bool
    init(title: String, scroll: Bool = true, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
        self.scroll = scroll
    }
    
    var contentView: some View {
        VStack(alignment: .leading){
            VStack(alignment: .leading, spacing: 20) {
                Image("GetStartedLogo")
                    .padding(.top, 3)
                Text(title)
                    .font(Font.custom("Urbanist", size: 32).weight(.bold))
//                    .font(Font.system(size: 32, weight: .bold))
            }
            content
        }
        
    }
    
    var body: some View {
        Background(color: Color("BackgroundColor")) {
            if scroll {
                GeometryReader { geometry in
                    ScrollView {
                        contentView
                            .frame(minHeight: geometry.size.height)
                            .padding(.horizontal)
                    }
                }
            } else {
                contentView
                    .padding(.horizontal)
            }
        }
        .onTapGesture {
            UIApplication.shared.endEditing()
        }
    }
}

struct BasicLayoutView_Previews: PreviewProvider {
    static var previews: some View {
        BasicLayoutView(title: "Welcome back! Glad to see you, Again!") {
            Text("Hello")
        }
    }
}
