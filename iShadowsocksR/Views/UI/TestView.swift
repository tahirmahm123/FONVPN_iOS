//
//  TestView.swift
//  iShadowsocksR
//
//  Created by Tahir M. on 11/08/2023.
//  Copyright © 2023 DigitalD.Tech. All rights reserved.
//

import SwiftUI
import UIKit

struct TestViewWrapper: UIViewRepresentable {
    func makeUIView(context: Context) -> UIView {
        let image = "de" // Replace with your image name
        let text = "Dynamic Text"
//        let imageWidth: CGFloat = 100 // Adjust the width as needed
//        let imageHeight: CGFloat = 100 // Adjust the height as needed
        
        let view = LocationTag(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: 150, height: 40)))
        view.imageView.image = UIImage(named: image)
        view.label.text = text
//        let view = LocationTag(image: image, text: text)
//        view.frame = CG/*Rect(x: 20, y: 20, width: imageWidth + 10 + 200, height: imageHeight) // Adjust the width as needed*/
        return view
    }
    
    func updateUIView(_ view: UIView, context: Context) {
    }
}

struct TestView: View {
    var body: some View {
        TestViewWrapper()
//            .frame(width: 150, height: 150)
            .background(Color.red)
    }
}

struct TestView_Previews: PreviewProvider {
    static var previews: some View {
        TestView()
    }
}
