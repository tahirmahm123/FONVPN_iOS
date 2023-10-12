//
//  FavouritesBackground.swift
//  VPN-Lightning
//
//  Created by Tahir M. on 07/07/2023.
//  Copyright © 2023 Onion Tech Ltd. All rights reserved.
//

import SwiftUI
import UIKit

//class FavouritesBackground: UIView {
//    
//    @IBOutlet var container: UIView!
//        // This method will be called when loading the view from the XIB file
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        commonInit()
//    }
//    
//        // This method will be called when loading the view from Interface Builder
//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//        commonInit()
//    }
//    
//        // Load the XIB file and add its contents to this view
////    private func commonInit() {
////        let nib = UINib(nibName: "FavouritesBackground", bundle: nil)
////        if let view = nib.instantiate(withOwner: self, options: nil).first as? UIView {
////            view.frame = bounds
////            view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
////            addSubview(view)
////        }
////    }
//    func commonInit() {
//        Bundle.main.loadNibNamed("FavouritesBackground", owner: self, options: nil)
//        container.fixInView(self)
//    }
//}

struct FavouritesBackground: View {
    
    var body: some View {
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

struct FavouritesBackground_Previews: PreviewProvider {
    static var previews: some View {
        FavouritesBackground()
    }
}

