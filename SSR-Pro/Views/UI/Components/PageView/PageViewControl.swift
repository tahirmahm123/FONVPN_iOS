//
//  PageViewControl.swift
//  iShadowsocksR
//
//  Created by Tahir M. on 27/07/2023.
//  Copyright © 2023 myGreateOrg. All rights reserved.
//

import SwiftUI

struct PageViewControl: View {
    var body: some View {
        PageView(pages: (0...2).map {
            LoginPageControl(index: $0)
        })
    }
}

struct PageViewControl_Previews: PreviewProvider {
    static var previews: some View {
        PageViewControl()
            .environmentObject(AppRouter())
    }
}
