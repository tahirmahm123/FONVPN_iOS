

import SwiftUI
import UIKit
import SwiftUI
import Lottie

class CoordinatesFinder {
    
    private var worldMap: UIImageView!
    private var latitude: Double
    private var longitude: Double
    private var name: String
    private var currentLocation: Bool
    
    init(forLatitude latitude: String?, andLongitude longitude: String?, usingImageSize imageView: UIImageView, forServer name: String, currentLocation: Bool = false) {
        self.worldMap = imageView
        self.latitude = Double(latitude ?? "0") ?? 0.0
        self.longitude = Double(longitude ?? "0") ?? 0.0
        self.name = name
        self.currentLocation = currentLocation
    }
    
    private var markerRadius = 2.0
    
    
    private var topLat = 82.35
    private var bottomLat = -54.00
    private var leftLong = -168.17
    private var rightLong = -169.50
    
        // Top and bottom, Miller-projected
    private func topMiller() -> Float {
        return millerProjectLat(latitudeDeg: topLat)
    }
    private func bottomMiller() -> Float {
        return millerProjectLat(latitudeDeg: bottomLat)
    }
    
    private func degToRad(degrees: Float) -> Float {
        return degrees * Float.pi / 180.0
    }
    
        // Project latitude.  The map uses this projection:
        // https://en.wikipedia.org/wiki/Miller_cylindrical_projection
    private func millerProjectLat(latitudeDeg: Double) -> Float {
        return 1.25 * log2f(tan(Float.pi * 0.25 + 0.4 * degToRad(degrees: Float(latitudeDeg))))
    }
    
    private var locationX: Double {
        
            // Longitude is locationMeta.long -> range [-180, 180]
        var x = longitude
            // Adjust for actual left edge of graphic -> range [-168, 192]
        if(x < leftLong) {
            x += 360.0
        }
            // Map to [0, width]
        let mapWidth = Double(worldMap.frame.size.width)
        let a = x - leftLong
        let b = rightLong - leftLong
        return (a / (b + 360.0)) * mapWidth
        
    }
    
    private var locationY: Double {
        
            // Project the latitude -> range [-2.3034..., 2.3034...]
        let millerLat = millerProjectLat(latitudeDeg: latitude)
        
            // Map to the actual range shown by the map.  (If this point is outside
            // the map bound, it returns a negative value or a value greater than
            // height.)
            // Map to unit range -> [0, 1], where 0 is the bottom and 1 is the top
        let unitY = (millerLat - bottomMiller()) / (topMiller() - bottomMiller())
        
            // Flip and scale to height
        return (1.0-Double(unitY)) * Double(worldMap.frame.size.height)
        
    }
    
    var mapPointX: Double {
        return round(locationX)
    }
    
    var mapPointY: Double {
        return round(locationY)
    }
    
    private var showLocation: Bool {
        return mapPointX >= 0 && mapPointX < Double(worldMap.frame.size.width) &&
        mapPointY >= 0 && mapPointY < Double(worldMap.frame.size.height)
    }
    
        // We're aligning this dot to a non-directional image, so reflect X when RTL
        // mirror is on.
    private var x: Double {
        return mapPointX - markerRadius
    }
    
    private var y: Double {
        return mapPointY - markerRadius
    }
    
    
    func dot() -> UIView {
        let helper = DotHelper(x: locationX, y: locationY)
        
        return  helper.greenDot()
    }
}

class DotHelper: NSObject {
    
    let locationX: CGFloat
    let locationY: CGFloat
    
    init(x locationX: CGFloat, y locationY: CGFloat) {
        self.locationX = locationX
        self.locationY = locationY
    }
    
    private func innetDotRectInMap(_ radius: CGFloat) -> CGRect {
        return CGRect(x: radius,
                      y: radius,
                      width: radius*2,
                      height: radius*2)
    }
    
    private func outerDotRectInMap(_ radius: CGFloat) -> CGRect {
        return CGRect(x: locationX - radius*2,
                      y: locationY - radius*2,
                      width: radius*4,
                      height: radius*4)
    }
    
    
        /// Returns the dot pointing to the coordinates
    func redDot() -> UIView {
        let color = vpnStatus == .on ? UIColor.green : UIColor.red
        let outerRadius = 30.0
        let outerDot = UIView(frame: CGRect(x: locationX - outerRadius,
                                            y: locationY - outerRadius,
                                            width: outerRadius*2,
                                            height: outerRadius*2))
        outerDot.backgroundColor = color.withAlphaComponent(0.1)
        outerDot.layer.borderColor = UIColor.clear.cgColor
        outerDot.layer.borderWidth = 1.0/2
        outerDot.layer.cornerRadius = CGFloat(outerRadius)
        
        let innerRadius = 3.0
        let innerDot = UIView(frame: CGRect(x: outerRadius - innerRadius,
                                            y: outerRadius - innerRadius,
                                            width: innerRadius*2,
                                            height: innerRadius*2))
        innerDot.backgroundColor = vpnStatus == .on ? UIColor.green : UIColor.red
        
        innerDot.layer.cornerRadius = CGFloat(innerRadius)
        outerDot.addSubview(innerDot)
//        if vpnStatus == .connected {
//            outerDot.addRippleEffect(color: color, radius: outerRadius / 2.0)
//        }
        return outerDot
    }
    func greenDot() -> UIView {
        let innerDot = UIImageView(frame: self.outerDotRectInMap(1.5))
        innerDot.image = UIImage(systemName: "circle.fill")
        return innerDot
    }
}
