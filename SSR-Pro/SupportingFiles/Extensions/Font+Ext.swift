//
//  Font.swift
//  VirgoVPN
//
//  Created by Tahir M. on 15/09/2023.
//

import SwiftUI

extension Font {
    static let appFont = "Urbanist"
    static func urbanist(size: CGFloat, weight: Font.Weight) -> Font {
        return Font.custom(Font.appFont, size: size).weight(weight)
    }
    static func urbanistRegular(size: CGFloat) -> Font {
        return Font.urbanist(size: size, weight: .regular)
    }
    static func urbanistMedium(size: CGFloat) -> Font {
        return Font.urbanist(size: size, weight: .medium)
    }
    static func urbanistSemiBold(size: CGFloat) -> Font {
        return Font.urbanist(size: size, weight: .semibold)
    }
    static func urbanistBold(size: CGFloat) -> Font {
        return Font.urbanist(size: size, weight: .bold)
    }
    static func urbanistExtraBold(size: CGFloat) -> Font {
        return Font.custom("\(Font.appFont)-ExtraBold", size: size)
    }
    static func urbanistLight(size: CGFloat) -> Font {
        return Font.urbanist(size: size, weight: .light)
    }
    static func urbanistExtraLight(size: CGFloat) -> Font {
        return Font.urbanist(size: size, weight: .ultraLight)
    }
    static func urbanistThin(size: CGFloat) -> Font {
        return Font.urbanist(size: size, weight: .thin)
    }
    static func logoFont(size: CGFloat) -> Font {
        return Font.system(size: size, weight: .heavy)
    }
}
