//
//  UIManager.swift
//
//  Created by LEI on 12/27/15.
//  Copyright © 2015 TouchingApp. All rights reserved.
//

import Foundation
import ICSMainFramework
// import PotatsoLibrary
//import Aspects

class UIManager: NSObject, AppLifeCycleProtocol {
    
    var keyWindow: UIWindow? {
        return UIApplication.shared.keyWindow
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        UIView.appearance().tintColor = AppColor.Brand
        
        UITableView.appearance().backgroundColor = AppColor.Background
        UITableView.appearance().separatorColor = AppColor.Separator
        
        UINavigationBar.appearance().backgroundColor = .clear
        UINavigationBar.appearance().barTintColor = AppColor.NavigationBackground
        
        UITabBar.appearance().isTranslucent = false
        UITabBar.appearance().backgroundColor = AppColor.TabBackground
        UITabBar.appearance().tintColor = AppColor.TabItemSelected
        var isUniversalLinkClick: Bool = false
        if let activityDictionary = launchOptions?[UIApplication.LaunchOptionsKey.userActivityDictionary] as? [AnyHashable: Any] {
            if activityDictionary["UIApplicationLaunchOptionsUserActivityKey"] is NSUserActivity {
                isUniversalLinkClick = true
            }
        }
        let token = userDefaults.string(forKey: urlAuthToken)
        let logedin = userDefaults.bool(forKey: isLogedIn)
        if !logedin && (isUniversalLinkClick || token != nil ){
            let vc = UINavigationController()
            vc.navigationBar.isHidden = true
            vc.setViewControllers([ControllerHelper.getStartedVC(nav: vc, login: true)], animated: false)
            keyWindow?.rootViewController = vc
            DispatchQueue.main.asyncAfter(deadline: .now()+0.5) {
                
                NotificationCenter.default.post(name: .LoginActionWithUrl, object: nil, userInfo: [
                    "token": token ?? ""
                ]);
            }
        } else {
            keyWindow?.rootViewController = makeRootViewController()
        }
        Receipt.shared.validate()
        return true
    }
    
//    func makeRootViewController() -> UITabBarController {
//        let tabBarVC = UITabBarController()
//        tabBarVC.viewControllers = makeChildViewControllers()
//        tabBarVC.selectedIndex = 0
//        return tabBarVC
//    }
//    
//    func makeChildViewControllers() -> [UIViewController] {
//        let cons: [(UIViewController.Type, String, String)] = [(HomeVC.self, "Home".localized(), "Home"), (DashboardVC.self, "Statistics".localized(), "Dashboard"), (CollectionViewController.self, "Manage".localized(), "Config"), (SettingsViewController.self, "More".localized(), "More")]
//        return cons.map {
//            let vc = UINavigationController(rootViewController: $0.init())
//            vc.tabBarItem = UITabBarItem(title: $1, image: $2.originalImage, selectedImage: $2.templateImage)
//            return vc
//        }
//    }
    
    func makeRootViewController() -> UINavigationController {
        let vc = UINavigationController()
        vc.navigationBar.isHidden = true
        vc.setViewControllers([SplashController.vc()], animated: false)
        return vc
    }
    
}
