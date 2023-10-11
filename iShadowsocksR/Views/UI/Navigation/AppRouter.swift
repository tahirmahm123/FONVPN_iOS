//
//  CheckoutNavigation.swift
//  CustomUIKitNavigation
//
//  Created by Everton Carneiro on 05/04/22.
//

import UIKit
import SwiftUI
final class AppRouter: Router {
    var nav: UINavigationController?
    
    func pushTo(view: UIViewController) {
        nav?.pushViewController(view, animated: true)
    }
    func present(view: UIViewController) {
        nav?.present(view, animated: true)
    }
    
    func popTo(view: UIViewController) {
        nav?.popToViewController(view, animated: true)
    }
    func pushToUI<T: View>(_ view: T, withNavigationTitle title: String, backButton: String) {
        nav?.pushViewController(self.makeUI(view, withNavigationTitle: title), animated: true)
        nav?.navigationItem.backButtonTitle = backButton
    }
    
    func popToUI<T: View>(_ view: T, withNavigationTitle title: String) {
        nav?.popToViewController(self.makeUI(view, withNavigationTitle: title), animated: true)
    }
    func present<T: View>(_ view: T) {
//        nav?.present(UIHostin , animated: <#T##Bool#>)
    }
    
    func presentVC(view: UIViewController) {
        nav?.present(view, animated: true)
    }
    
    func makeUI<T: View>(_ view: T, withNavigationTitle title: String) -> UIViewController {
        UIController(rootView: view, navigationBarTitle: title, navigationBarHidden: false)
    }
}

