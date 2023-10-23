//
//  TestViewWrapper.swift
//  VPN-Lightning
//
//  Created by Tahir M. on 07/07/2023.
//  Copyright © 2023 Onion Tech Ltd. All rights reserved.
//
import SwiftUI
import UIKit

struct CoordinateData: Identifiable, Hashable {
    let id: Int
    let name: String
    let latitude: Double
    let longitude: Double
    var x: Double
    var y: Double
    var isCurrentLocation: Bool = false
}

struct MapWithCoordinates: UIViewRepresentable {
    @EnvironmentObject var appConstants: AppConstants
    @Binding var pts: [CoordinateData]
    let height: CGFloat
    let width: CGFloat
    
    init(points : Binding<[CoordinateData]>, height: CGFloat, width: CGFloat ) {
        self._pts = points
        self.height = height
        self.width = width
    }
    
    func makeUIView(context: Context) -> UIView {
        let size = CGSize(width: width, height: height)
        
        let view = UIView(frame: CGRect(origin: CGPoint.zero, size: size))
        let imageView = UIImageView()
            // Replace "World" with the name of your image in the assets
        let image = UIImage(named: "WorldMap")
        imageView.image = image
        imageView.contentMode = .scaleAspectFit
            // Invert colors
        if let invertedImage = invertColors(in: imageView.image) {
            imageView.image = invertedImage
        }
        
            // Adjust brightness
        if let adjustedImage = applyBrightness(to: imageView.image, brightness: 0.5) {
            imageView.image = adjustedImage
        }
            // Set background color
//        imageView.backgroundColor = UIColor.blue
        
        pts = pts.map { coordinate in
            var newCoordinate = coordinate
            let dot = CoordinatesFinder(forLatitude: "\(coordinate.latitude)", andLongitude: "\(coordinate.longitude)", usingImageSize: imageView, forServer: coordinate.name, currentLocation: coordinate.isCurrentLocation)
            newCoordinate.x = dot.mapPointX
            newCoordinate.y = dot.mapPointY
            imageView.addSubview(dot.dot())
            print("Location: \(coordinate.name)")
            return newCoordinate
        }
        NotificationCenter.default.addObserver(forName: .FocusOnMap, object: nil, queue: nil, using: { notification in
            let dictionary = notification.userInfo as! [String: Int]
            let serverId = dictionary["id"]!
//            let coordinate = pts.filter { coordinate in
//                return coordinate.id == serverId
//            }.first
//            let screenBounds = UIScreen.main.bounds
//            let xCoordinate = abs((screenBounds.width*0.5) - (coordinate?.x ?? 0.0))
//            let yCoordinate = abs((screenBounds.height*0.25) - (coordinate?.y ?? 0.0))
//            scrollView.setContentOffset(CGPoint(x: xCoordinate, y: yCoordinate), animated: true)
            print("Focused On Location")
        })
        view.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
            // Set Auto Layout constraints to stick the image view to the edges of the parent view
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        return view
    }
    
    func updateUIView(_ view: UIView, context: Context) {
        let imageView = view.subviews[0] as! UIImageView
        imageView.subviews.forEach { subView in
                // removing subView from its parent view
            subView.removeFromSuperview()
        }
        pts = pts.map { coordinate in
            var newCoordinate = coordinate
            let dot = CoordinatesFinder(forLatitude: "\(coordinate.latitude)", andLongitude: "\(coordinate.longitude)", usingImageSize: imageView, forServer: coordinate.name, currentLocation: coordinate.isCurrentLocation)
            newCoordinate.x = dot.mapPointX
            newCoordinate.y = dot.mapPointY
            imageView.addSubview(dot.dot())
            print("Location: \(coordinate.name)")
            return newCoordinate
        }
        switch (vpnStatus) {
            case .on, .connecting:
                UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
                let serverId = userDefaults.integer(forKey: LastSelectedServer)
                NotificationCenter.default.post(name: .FocusOnMap, object: nil, userInfo: ["id": serverId])
            case .off, .disconnecting:
                NotificationCenter.default.post(name: .FocusOnMap, object: nil, userInfo: ["id": 0])
//            @unknown default:
//                NotificationCenter.default.post(name: .FocusOnMap, object: nil, userInfo: ["id": 0])
        }
    }
    
        // Function to invert colors manually
    func invertColors(in image: UIImage?) -> UIImage? {
        guard let image = image, let cgImage = image.cgImage else { return nil }
        
        let context = CIContext(options: nil)
        let coreImage = CIImage(cgImage: cgImage)
        let filter = CIFilter(name: "CIColorInvert")
        filter?.setValue(coreImage, forKey: kCIInputImageKey)
        
        if let outputImage = filter?.outputImage,
           let invertedCGImage = context.createCGImage(outputImage, from: coreImage.extent) {
            return UIImage(cgImage: invertedCGImage)
        }
        
        return nil
    }
    
        // Function to adjust brightness manually
    func applyBrightness(to image: UIImage?, brightness: CGFloat) -> UIImage? {
        guard let image = image, let cgImage = image.cgImage else { return nil }
        
        let context = CIContext(options: nil)
        let coreImage = CIImage(cgImage: cgImage)
        let filter = CIFilter(name: "CIColorControls")
        filter?.setValue(coreImage, forKey: kCIInputImageKey)
        filter?.setValue(brightness, forKey: kCIInputBrightnessKey)
        
        if let outputImage = filter?.outputImage,
           let adjustedCGImage = context.createCGImage(outputImage, from: coreImage.extent) {
            return UIImage(cgImage: adjustedCGImage)
        }
        
        return nil
    }
}
