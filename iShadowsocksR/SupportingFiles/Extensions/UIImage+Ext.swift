//
//  UIImage+Ext.swift
//  VPN-Lightning
//
//  Created by Tahir M. on 10/05/2023.
//  Copyright © 2023 Onion Tech Ltd. All rights reserved.
//

import UIKit
extension UIImage {
    func withRoundedCorners(cornerRadius: CGFloat, size imageSize: CGSize = CGSize(width: 0, height: 0)) -> UIImage? {
        var sizeToBeUsed = imageSize
        if imageSize.width == 0 {
            sizeToBeUsed = size
        }
        UIGraphicsBeginImageContextWithOptions(sizeToBeUsed, false, scale)
        let clippingPath = UIBezierPath(roundedRect: CGRect(origin: .zero, size: sizeToBeUsed), cornerRadius: cornerRadius)
        clippingPath.addClip()
        draw(in: CGRect(origin: .zero, size: sizeToBeUsed))
        let roundedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return roundedImage
    }
}
