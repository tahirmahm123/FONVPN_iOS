//
//  RandomFastestView.swift
//  VPN-Lightning
//
//  Created by Tahir M. on 13/06/2023.
//  Copyright © 2023 Onion Tech Ltd. All rights reserved.
//

import SwiftUI

struct RandomFastestView: View {
    var isFastest: Bool = false
    var body: some View {
        HStack() {
            if isFastest {
                Image("FastServerIcon")
                Text("Fastest Server")
            } else {
                Image("RandomServerIcon")
                Text("Random Server")
            }
            Spacer()
        }
        .background(Color(UIColor.systemBackground))
        .cornerRadius(8.0)
    }
}

struct RandomFastestView_Previews: PreviewProvider {
    static var previews: some View {
        RandomFastestView(isFastest: true)
    }
}
