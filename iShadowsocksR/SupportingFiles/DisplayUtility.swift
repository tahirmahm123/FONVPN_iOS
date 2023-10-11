//
//  DisplayUtility.swift
//  VPN-Lightning
//
//  Created by Tahir M. on 22/06/2023.
//  Copyright © 2023 Onion Tech Ltd. All rights reserved.
//

import Foundation
import UIKit

class DisplayUtility {
    
    static var shared = DisplayUtility()
    
    @UserDefaultsWrapper(key:SelectedApperance, defaultValue: 0)
    var selectedAppearance: Int
    
    var userInterfaceStyle: UIUserInterfaceStyle? = .dark
    
    func getDisplayMode() -> UIUserInterfaceStyle{
        var userInterfaceStyle: UIUserInterfaceStyle
        
        if selectedAppearance == 2 {
            userInterfaceStyle = .dark
        } else if selectedAppearance == 1 {
            userInterfaceStyle = .light
        } else {
            userInterfaceStyle = .unspecified
        }
        return userInterfaceStyle
    }
    
    func overrideDisplayMode() {
        let userInterfaceStyle: UIUserInterfaceStyle = getDisplayMode()
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            windowScene.windows.first?.overrideUserInterfaceStyle = userInterfaceStyle
        }
    }
    
    func updateDisplayMode(_ mode: Int) {
        selectedAppearance = mode
        overrideDisplayMode()
    }
}

@propertyWrapper
struct UserDefaultsWrapper<T> {
    let key: String
    let defaultValue: T
    
    var wrappedValue: T {
        get {
            return UserDefaults.standard.object(forKey: key) as? T ?? defaultValue
        }
        set {
            UserDefaults.standard.set(newValue, forKey: key)
        }
    }
}
