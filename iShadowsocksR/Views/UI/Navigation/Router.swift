//
//  Router.swift
//  CustomUIKitNavigation
//
//  Created by Everton Carneiro on 06/04/22.
//

import UIKit
import Combine

protocol Router: ObservableObject {
    var nav: UINavigationController? { get set }
    func pushTo(view: UIViewController)
    func popTo(view: UIViewController)
    func present(view: UIViewController)
    func popToRoot()
    func pop()
    func setRoot(views: [UIViewController])
}

extension Router {
    func popToRoot() {
        nav?.popToRootViewController(animated: true)
    }
    func pop() {
        nav?.popViewController(animated: true)
    }
    
    func setRoot(views: [UIViewController]) {
        nav?.setViewControllers(views, animated: true)
    }
}
