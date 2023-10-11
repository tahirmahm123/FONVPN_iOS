//
//  TestView.swift
//  VPN-Lightning
//
//  Created by Tahir M. on 13/06/2023.
//  Copyright © 2023 Onion Tech Ltd. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @State var content = ["row1", "row2\nrow2\nrow2", "row3"]
    @State var rowHeight: CGFloat = 0
    
    var body: some View {
//        List {
//            ForEach(0..<content.count, id: \.self) { index in
//                Text(self.content[index])
//                    .frame(minHeight: self.rowHeight)  // set height as max height
//                    .background(
//                        GeometryReader{ (proxy) in
//                            Color.clear.preference(key: SizePreferenceKey.self, value: proxy.size)
//                        })
//                    .onPreferenceChange(SizePreferenceKey.self) { (preferences) in
//                        let currentSize: CGSize = preferences
//                        if (currentSize.height > self.rowHeight) {
//                            self.rowHeight = currentSize.height     //As height get change upto max height , put value in self.rowHeight
//                        }
//                    }
//            }
//        }
//            TestViewWrapper()
        VStack {
            Image("FavouritesBackground")
            Text("Your Favourite servers will be displayed here")
                .font(Font.custom("Urbanist", size: 18).weight(.semibold))
                .multilineTextAlignment(.center)
            Text("Save your time by creating your won list of servers.")
                .font(Font.custom("Urbanist", size: 14).weight(.regular))
                .foregroundColor(Color(UIColor.secondaryLabel))
                .multilineTextAlignment(.center)
        }.padding()
    }
}

struct SizePreferenceKey: PreferenceKey {
    typealias Value = CGSize
    static var defaultValue: Value = .zero
    
    static func reduce(value: inout Value, nextValue: () -> Value) {
        nextValue()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
