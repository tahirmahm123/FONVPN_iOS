//
//  SafariView.swift
//  VPN-Lightning
//
//  Created by Tahir M. on 04/09/2023.
//  Copyright © 2023 Onion Tech Ltd. All rights reserved.
//

import SafariServices
import UIKit
import SwiftUI

struct SafariView: UIViewControllerRepresentable {
    var url: URL
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<SafariView>) -> SFSafariViewController {
        let config = SFSafariViewController.Configuration()
        config.entersReaderIfAvailable = true
        let safariView = SFSafariViewController(url: url, configuration: config)
        return safariView
    }
    
    func updateUIViewController(_ uiViewController: SFSafariViewController, context: UIViewControllerRepresentableContext<SafariView>) {
        
    }
}
