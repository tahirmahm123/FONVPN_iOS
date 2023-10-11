//
//  CALayer+Ext.swift
//  VPN-Lightning
//
//  Created by Tahir M. on 26/05/2023.
//  Copyright © 2023 Onion Tech Ltd. All rights reserved.
//


import UIKit

extension CALayer {
    
    enum GradientDirection {
        case vertical, horizontal
        
        var startPoint: CGPoint {
            switch self {
                case .vertical:             return CGPoint(x: 0.5, y: 0)
                case .horizontal:           return CGPoint(x: 0, y: 0.5)
            }
        }
        
        var endPoint: CGPoint {
            switch self {
                case .vertical:             return CGPoint(x: 0.5, y: 1)
                case .horizontal:           return CGPoint(x: 1, y: 0.5)
            }
        }
    }
    
    @discardableResult
    func addGradientBorder(direction: CALayer.GradientDirection, lineWidth: CGFloat, colors: [UIColor]) -> CAGradientLayer {
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = CGRect(x: 0, y: 0, width: bounds.size.width, height: bounds.size.height)
        gradientLayer.startPoint = direction.startPoint
        gradientLayer.endPoint = direction.endPoint
        gradientLayer.colors = colors.map{$0.cgColor}
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.lineWidth = lineWidth
        let movedPath = CGRect(x: shapeLayer.lineWidth / 2 , y: shapeLayer.lineWidth / 2, width: bounds.size.width - shapeLayer.lineWidth, height: bounds.size.height - shapeLayer.lineWidth)
            ///Preventing top left empty corner
            ///Underthehood calculations are different
        if cornerRadius == 0 {
            shapeLayer.path = UIBezierPath(rect: movedPath).cgPath
        } else {
            shapeLayer.path = UIBezierPath(roundedRect: movedPath, cornerRadius: cornerRadius).cgPath
        }
        shapeLayer.fillColor = nil
        shapeLayer.strokeColor = UIColor.white.cgColor
        gradientLayer.mask = shapeLayer
        insertSublayer(gradientLayer, at: 0)
        return gradientLayer
    }
    
    @discardableResult
    func addFillGradient(direction: CALayer.GradientDirection = .horizontal, colors: [UIColor]) -> CAGradientLayer {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = CGRect(x: 0, y: 0, width: bounds.size.width, height: bounds.size.height)
        gradientLayer.startPoint = direction.startPoint
        gradientLayer.endPoint = direction.endPoint
        gradientLayer.colors = colors.map{$0.cgColor}
        insertSublayer(gradientLayer, at: 0)
        return gradientLayer
    }
    
}
