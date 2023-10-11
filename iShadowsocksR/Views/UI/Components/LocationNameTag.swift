//
//  LocationNameTag.swift
//  iShadowsocksR
//
//  Created by Tahir M. on 28/09/2023.
//  Copyright © 2023 DigitalD.Tech. All rights reserved.
//

import Foundation
import UIKit

class LocationTag: UIView {
//    private let imageView: UIImageView = {
//        let imageView = UIImageView()
//        imageView.contentMode = .scaleAspectFit
//        return imageView
//    }()
//    
//    private let label: UILabel = {
//        let label = UILabel()
//        label.textAlignment = .center
//        return label
//    }()
    @IBOutlet weak var container: UIView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
//        Bundle.main.loadNibNamed("LocationTag", owner: self, options: nil)
//        container.fixInView(self)
        guard let view = loadViewFromNib() else { return }
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(view)
    }
    
    private func loadViewFromNib() -> UIView? {
        let nib = UINib(nibName: String(describing: LocationTag.self), bundle: nil)
        return nib.instantiate(withOwner: self, options: nil).first as? UIView
    }
    convenience init(image: String, text: String) {
        self.init()
//        self.init(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: 150, height: 100)))
        imageView.image = UIImage(named: image)
        label.text = text
//        imageView.widthAnchor.constraint(equalToConstant: 50).isActive = true
//        imageView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        commonInit()
    }
    
//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//        setupUI()
//    }
    
    private func setupUI() {
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(containerView)
        containerView.addSubview(imageView)
        containerView.addSubview(label)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: topAnchor),
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            imageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            imageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            
            label.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 10), // Adjust spacing as needed
            label.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            label.centerYAnchor.constraint(equalTo: containerView.centerYAnchor)
        ])
    }
}
