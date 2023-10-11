//
//  UIView+Ext.swift
//  OnionVPN
//
//  Created by Tahir M. on 03/05/2023.
//  Copyright © 2023 Onion Tech Ltd. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    func addshadow(top: Bool,left: Bool,bottom: Bool,right: Bool,shadowRadius: CGFloat = 2.0) {
        
        self.layer.masksToBounds = false
        self.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        self.layer.shadowRadius = shadowRadius
        self.layer.shadowOpacity =  1
        self.layer.shadowColor = UIColor.lightGray.withAlphaComponent(0.2).cgColor
        let path = UIBezierPath()
        var x: CGFloat = 0
        var y: CGFloat = 2
        var viewWidth = UIScreen.main.bounds.width
        var viewHeight = self.frame.height
        
        if (!top) {
            y+=(shadowRadius+1)
        }
        if (!bottom) {
            viewHeight-=(shadowRadius+1)
        }
        if (!left) {
            x+=(shadowRadius+1)
        }
        if (!right) {
            viewWidth-=(shadowRadius+1)
        }
            // selecting top most point
        path.move(to: CGPoint(x: x, y: y))
        path.addLine(to: CGPoint(x: x, y: viewHeight))
        path.addLine(to: CGPoint(x: viewWidth, y: viewHeight))
        path.addLine(to: CGPoint(x: viewWidth, y: y))
        path.close()
        self.layer.shadowPath = path.cgPath
    }
    func  addTapGesture(action : @escaping ()->Void ){
        let tap = MyTapGestureRecognizer(target: self , action: #selector(self.handleTap(_:)))
        tap.action = action
        tap.numberOfTapsRequired = 1
        
        self.addGestureRecognizer(tap)
        self.isUserInteractionEnabled = true
        
    }
    
    @objc func handleTap(_ sender: MyTapGestureRecognizer) {
        sender.action!()
    }
    
    func setBackgroundGradientLayer(_ radius: CGFloat = 8, shadow: Bool = true) {
        let _ = self.applyGradient(colors: [
            UIColor(named: "BackgroundGradientColor1")!.cgColor,
            UIColor(named: "BackgroundGradientColor2")!.cgColor
        ], radius: radius,direction: [CGPoint(x: 0, y: 0),CGPoint(x: 1, y: 0)], shadow: shadow)
    }
    
    func setThemeGradientLayer(_ radius: CGFloat, shadow: Bool = true) {
        let _ = self.applyGradient(colors: [UIColor(red: 0/255, green: 5/255, blue: 73/255, alpha: 1.0).cgColor, UIColor(red: 78/255, green: 184/255, blue: 234/255, alpha: 1.0).cgColor], radius: radius,direction: [CGPoint(x: 0, y: 0),CGPoint(x: 1, y: 0)], shadow: shadow)
    }
    
    func setThemeBorderGradientLayer(_ radius: CGFloat, shadow: Bool = true) -> CAGradientLayer {
        return self.layer.addGradientBorder(direction: .horizontal, lineWidth: 2, colors: [UIColor(red: 0/255, green: 5/255, blue: 73/255, alpha: 1.0), UIColor(red: 78/255, green: 184/255, blue: 234/255, alpha: 1.0)])
    }
    func applyGradient(colors: [CGColor], radius: CGFloat, direction: [CGPoint], shadow: Bool = true) -> CAGradientLayer {
        self.backgroundColor = nil
        self.layoutIfNeeded()
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = colors
        gradientLayer.startPoint = direction[0]
        gradientLayer.endPoint = direction[1]
        gradientLayer.frame = self.bounds
        gradientLayer.cornerRadius = radius
        if shadow {
            gradientLayer.shadowColor = UIColor.darkGray.cgColor
            gradientLayer.shadowOffset = CGSize(width: 2.5, height: 2.5)
            gradientLayer.shadowRadius = 5.0
            gradientLayer.shadowOpacity = 0.3
        }
        gradientLayer.masksToBounds = false
        
        self.layer.insertSublayer(gradientLayer, at: 0)
        return gradientLayer
    }
    func applyBorderGradient(colors: [CGColor], radius: CGFloat, direction: [CGPoint], shadow: Bool = true) -> CAGradientLayer {
        self.backgroundColor = nil
        self.layoutIfNeeded()
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = colors
        gradientLayer.startPoint = direction[0]
        gradientLayer.endPoint = direction[1]
        gradientLayer.frame = self.bounds
        gradientLayer.cornerRadius = radius
        if shadow {
            gradientLayer.shadowColor = UIColor.darkGray.cgColor
            gradientLayer.shadowOffset = CGSize(width: 2.5, height: 2.5)
            gradientLayer.shadowRadius = 5.0
            gradientLayer.shadowOpacity = 0.3
        }
        let shape = CAShapeLayer()
        shape.lineWidth = 2
        shape.path = UIBezierPath(rect: self.bounds).cgPath
        shape.strokeColor = UIColor.black.cgColor
        shape.fillColor = UIColor.systemBackground.cgColor
        gradientLayer.mask = shape

        gradientLayer.masksToBounds = true
        
        self.layer.addSublayer(gradientLayer)
        self.layer.addSublayer(shape)
        return gradientLayer
    }
    
    func hideKeyboardOnTap() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        self.addGestureRecognizer(tap)
    }
    @objc func dismissKeyboard() {
        self.endEditing(true)
    }
}
//extension UIView {
//        //MARK: - View cycles
//    func layoutSubviews() {
//        layoutSubviews()
//        updateStateVisually()
//    }
//   
//    
//}
