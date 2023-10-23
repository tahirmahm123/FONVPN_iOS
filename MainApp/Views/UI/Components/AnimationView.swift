//
//  LoaderAnimation.swift
//  VPN-Lightning
//
//  Created by Tahir M. on 31/05/2023.
//  Copyright © 2023 Onion Tech Ltd. All rights reserved.
//


import SwiftUI
import Lottie

struct AnimationView: UIViewRepresentable {
    let name: String
    let loopMode: LottieLoopMode
    let animationSpeed: CGFloat
    let contentMode: UIView.ContentMode
    @Binding var play: Bool
    
//    let animationView: LottieView
    
    init(name: String,
         loopMode: LottieLoopMode = .loop,
         animationSpeed: CGFloat = 1,
         contentMode: UIView.ContentMode = .scaleAspectFit,
         play: Binding<Bool> = .constant(true)) {
        self.name = name
//        self.animationView = AnimationView(name: name)
        self.loopMode = loopMode
        self.animationSpeed = animationSpeed
        self.contentMode = contentMode
        self._play = play
    }
    
    func makeUIView(context: Context) -> UIView {
        let view = UIView(frame: .zero)
//        view.addSubview(animationView)
//        animationView.contentMode = contentMode
//        animationView.translatesAutoresizingMaskIntoConstraints = false
//        animationView.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
//        animationView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
//        animationView.loopMode = loopMode
//        animationView.animationSpeed = animationSpeed
        
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
//        if play {
//            animationView.play { _ in
//                play = false
//            }
//        }
    }
    
}
