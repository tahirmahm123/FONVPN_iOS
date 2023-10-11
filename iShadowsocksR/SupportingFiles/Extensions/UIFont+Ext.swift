//
//  File.swift
//  VPN-Lightning
//
//  Created by Tahir M. on 07/05/2023.
//  Copyright © 2023 Onion Tech Ltd. All rights reserved.
//

import UIKit

struct AppFontName {
    static let regular = "Urbanist-Regular"
    static let italic = "Urbanist-Italic"
    static let medium = "Urbanist-Medium"
    static let mediumItalic = "Urbanist-MediumItalic"
    static let semiBold = "Urbanist-SemiBold"
    static let semiBoldItalic = "Urbanist-SemiBoldItalic"
    static let bold = "Urbanist-Bold"
    static let boldItalic = "Urbanist-BoldItalic"
    static let extraBold = "Urbanist-ExtraBold"
    static let extraBoldItalic = "Urbanist-ExtraBoldItalic"
    static let light = "Urbanist-Light"
    static let extraLight = "Urbanist-ExtraLight"
    static let extraLightItalic = "Urbanist-ExtraLightItalic"
    static let thin = "Urbanist-Thin"
    static let thinItalic = "Urbanist-ThinItalic"
}

    // Customize font
extension UIFontDescriptor.AttributeName {
    static let nsctFontUIUsage = UIFontDescriptor.AttributeName(rawValue: "NSCTFontUIUsageAttribute")
}

extension UIFont {
    
    @objc class func mySystemFont(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: AppFontName.regular, size: size)!
    }
    
    @objc class func myBoldSystemFont(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: AppFontName.bold, size: size)!
    }
    
    @objc class func myItalicSystemFont(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: AppFontName.italic, size: size)!
    }
    
        // Add additional font styles
    
    @objc class func myMediumSystemFont(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: AppFontName.medium, size: size)!
    }
    
    @objc class func myMediumItalicSystemFont(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: AppFontName.mediumItalic, size: size)!
    }
    
    @objc class func mySemiBoldSystemFont(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: AppFontName.semiBold, size: size)!
    }
    
    @objc class func mySemiBoldItalicSystemFont(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: AppFontName.semiBoldItalic, size: size)!
    }
    
    @objc class func myExtraBoldSystemFont(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: AppFontName.extraBold, size: size)!
    }
    
    @objc class func myExtraBoldItalicSystemFont(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: AppFontName.extraBoldItalic, size: size)!
    }
    
    @objc class func myLightSystemFont(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: AppFontName.light, size: size)!
    }
    
    @objc class func myExtraLightSystemFont(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: AppFontName.extraLight, size: size)!
    }
    
    @objc class func myExtraLightItalicSystemFont(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: AppFontName.extraLightItalic, size: size)!
    }
    
//    @objc class func myThinSystemFont(ofSize size: CGFloat) -> UIFont {
//        return UIFont(name: AppFontName.thin, size: size)!
//    }
    
    @objc class func myThinItalicSystemFont(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: AppFontName.thinItalic, size: size)!
    }
    
    @objc convenience init(myCoder aDecoder: NSCoder) {
        guard
            let fontDescriptor = aDecoder.decodeObject(forKey: "UIFontDescriptor") as? UIFontDescriptor,
            let fontAttribute = fontDescriptor.fontAttributes[.nsctFontUIUsage] as? String else {
            self.init(myCoder: aDecoder)
            return
        }
        
        var fontName = ""
        
        switch fontAttribute {
            case "CTFontRegularUsage":
                fontName = AppFontName.regular
            case "CTFontItalicUsage":
                fontName = AppFontName.italic
            case "CTFontMediumUsage":
                fontName = AppFontName.medium
            case "CTFontMediumItalicUsage":
                fontName = AppFontName.mediumItalic
            case "CTFontSemiBoldUsage":
                fontName = AppFontName.semiBold
            case "CTFontSemiBoldItalicUsage":
                fontName = AppFontName.semiBoldItalic
            case "CTFontBoldUsage":
                fontName = AppFontName.bold
            case "CTFontBoldItalicUsage":
                fontName = AppFontName.boldItalic
            case "CTFontExtraBoldUsage":
                fontName = AppFontName.extraBold
            case "CTFontExtraBoldItalicUsage":
                fontName = AppFontName.extraBoldItalic
            case "CTFontLightUsage":
                fontName = AppFontName.light
            case "CTFontExtraLightUsage":
                fontName = AppFontName.extraLight
            case "CTFontExtraLightItalicUsage":
                fontName = AppFontName.extraLightItalic
            case "CTFontThinUsage":
                fontName = AppFontName.thin
            case "CTFontThinItalicUsage":
                fontName = AppFontName.thinItalic
            default:
                fontName = AppFontName.regular
        }
        
        self.init(name: fontName, size: fontDescriptor.pointSize)!
    }
    
    class func overrideInitialize() {
        guard self == UIFont.self else { return }
        
        if let systemFontMethod = class_getClassMethod(self, #selector(systemFont(ofSize:))),
           let mySystemFontMethod = class_getClassMethod(self, #selector(mySystemFont(ofSize:))) {
            method_exchangeImplementations(systemFontMethod, mySystemFontMethod)
        }
        
        if let boldSystemFontMethod = class_getClassMethod(self, #selector(boldSystemFont(ofSize:))),
           let myBoldSystemFontMethod = class_getClassMethod(self, #selector(myBoldSystemFont(ofSize:))) {
            method_exchangeImplementations(boldSystemFontMethod, myBoldSystemFontMethod)
        }
        
        if let italicSystemFontMethod = class_getClassMethod(self, #selector(italicSystemFont(ofSize:))),
           let myItalicSystemFontMethod = class_getClassMethod(self, #selector(myItalicSystemFont(ofSize:))) {
            method_exchangeImplementations(italicSystemFontMethod, myItalicSystemFontMethod)
        }
        
        
        if let mediumSystemFontMethod = class_getClassMethod(self, #selector(systemFont(ofSize:weight:))),
           let myMediumSystemFontMethod = class_getClassMethod(self, #selector(myMediumSystemFont(ofSize:))) {
            method_exchangeImplementations(mediumSystemFontMethod, myMediumSystemFontMethod)
        }
        
//        if let mediumItalicSystemFontMethod = class_getClassMethod(self, #selector(italicSystemFont(ofSize:weight:))),
//           let myMediumItalicSystemFontMethod = class_getClassMethod(self, #selector(myMediumItalicSystemFont(ofSize:))) {
//            method_exchangeImplementations(mediumItalicSystemFontMethod, myMediumItalicSystemFontMethod)
//        }
        
        if let semiBoldSystemFontMethod = class_getClassMethod(self, #selector(systemFont(ofSize:weight:))),
           let mySemiBoldSystemFontMethod = class_getClassMethod(self, #selector(mySemiBoldSystemFont(ofSize:))) {
            method_exchangeImplementations(semiBoldSystemFontMethod, mySemiBoldSystemFontMethod)
        }
        
//        if let semiBoldItalicSystemFontMethod = class_getClassMethod(self, #selector(italicSystemFont(ofSize:weight:))),
//           let mySemiBoldItalicSystemFontMethod = class_getClassMethod(self, #selector(mySemiBoldItalicSystemFont(ofSize:))) {
//            method_exchangeImplementations(semiBoldItalicSystemFontMethod, mySemiBoldItalicSystemFontMethod)
//        }
        
        if let extraBoldSystemFontMethod = class_getClassMethod(self, #selector(systemFont(ofSize:weight:))),
           let myExtraBoldSystemFontMethod = class_getClassMethod(self, #selector(myExtraBoldSystemFont(ofSize:))) {
            method_exchangeImplementations(extraBoldSystemFontMethod, myExtraBoldSystemFontMethod)
        }
        
//        if let extraBoldItalicSystemFontMethod = class_getClassMethod(self, #selector(italicSystemFont(ofSize:weight:))),
//           let myExtraBoldItalicSystemFontMethod = class_getClassMethod(self, #selector(myExtraBoldItalicSystemFont(ofSize:))) {
//            method_exchangeImplementations(extraBoldItalicSystemFontMethod, myExtraBoldItalicSystemFontMethod)
//        }
        
//        if let lightSystemFontMethod = class_getClassMethod(self, #selector(systemFont(ofSize:weight:))),
//           let myLightSystemFontMethod = class_getClassMethod(self, #selector(myLightSystemFont(ofSize:))) {
//            method_exchangeImplementations(lightSystemFontMethod, myLightSystemFontMethod)
//        }
        
//        if let extraLightSystemFontMethod = class_getClassMethod(self, #selector(systemFont(ofSize:weight:))),
//           let myExtraLightSystemFontMethod = class_getClassMethod(self, #selector(myExtraLightSystemFont(ofSize:))) {
//            method_exchangeImplementations(extraLightSystemFontMethod, myExtraLightSystemFontMethod)
//        }
        
//        if let extraLightItalicSystemFontMethod = class_getClassMethod(self, #selector(italicSystemFont(ofSize:weight:))),
//           let myExtraLightItalicSystemFontMethod = class_getClassMethod(self, #selector(myExtraLightItalicSystemFont(ofSize:))) {
//            method_exchangeImplementations(extraLightItalicSystemFontMethod, myExtraLightItalicSystemFontMethod)
//        }
        
//        if let thinSystemFontMethod = class_getClassMethod(self, #selector(systemFont(ofSize:weight:))),
//           let myThinSystemFontMethod = class_getClassMethod(self, #selector(myThinSystemFont(ofSize:))) {
//            method_exchangeImplementations(thinSystemFontMethod, myThinSystemFontMethod)
//        }
//
//        if let thinItalicSystemFontMethod = class_getClassMethod(self, #selector(italicSystemFont(ofSize:weight:))),
//           let myThinItalicSystemFontMethod = class_getClassMethod(self, #selector(myThinItalicSystemFont(ofSize:))) {
//            method_exchangeImplementations(thinItalicSystemFontMethod, myThinItalicSystemFontMethod)
//        }
    }
}

