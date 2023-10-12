/*
See LICENSE folder for this sample’s licensing information.

Abstract:
Creates the DiscloseView, EnableItem, SettingsDelegate, StoreManagerDelegate, and StoreObserverDelegate protocols that allow you to
 show/hide UI elements, enable/disable UI elements, notifies a listener about restoring purchases, manage StoreManager operations, and handle
 StoreObserver operations, respectively.
*/

import Foundation

// MARK: - DiscloseView

protocol DiscloseView {
    func show()
    func hide()
}

// MARK: - EnableItem

protocol EnableItem {
    func enable()
    func disable()
}
// MARK: - StoreObserverDelegate

protocol StoreObserverDelegate: AnyObject {
    /// Tells the delegate that the restore operation was successful.
    func storeObserverRestoreDidSucceed()
    
    /// Provides the delegate with messages.
    func storeObserverDidReceiveMessage(_ message: String)
}

// MARK: - SettingsDelegate

protocol SettingsDelegate: AnyObject {
    /// Tells the delegate that the user has requested the restoration of their purchases.
    func settingDidSelectRestore()
}
