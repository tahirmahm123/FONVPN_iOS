//
//  SplashController.swift
//  iShadowsocksR
//
//  Created by Tahir M. on 03/08/2023.
//  Copyright © 2023 DigitalD.Tech. All rights reserved.
//

import UIKit
import FirebaseMessaging

class SplashController: UIViewController, MessagingDelegate, UNUserNotificationCenterDelegate {

    @IBOutlet var containerView: UIView!
    @IBOutlet weak var background: UIImageView!
    @IBOutlet weak var progressView: UIProgressView!
    static func vc() -> SplashController {
        return UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController() as! SplashController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        containerView.setBackgroundGradientLayer()
        NotificationCenter.default.addObserver(self, selector: #selector(updateProgress(notification:)), name: .APIProgress, object: nil)
        self.progressView.progress = 0.0
        
        UNUserNotificationCenter.current().requestAuthorization(
            options: [.alert, .badge, .sound] as UNAuthorizationOptions,
            completionHandler: { res, err in
                print("response \(res)")
                print("err\(String(describing: err))")
            }
        )
        if userDefaults.bool(forKey: isLogedIn){
            Task {
                let done = await ApiManager.shared.updateData()
                print("Server List Fetched:  \(done ? "complete" : "failure" )")
                if done {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
                        self.navigateToLoginOrHome()
                    })
                } else {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
                        self.navigateToLogin()
                    })
                }
            }
        } else {
            self.navigateToLogin()
        }
    }
    
    
    
    @objc func navigateToLoginOrHome() {
        var initialViewController = ControllerHelper.getStartedVC(nav: self.navigationController!)
        if userDefaults.bool(forKey: isLogedIn){
            self.navigationController?.navigationBar.isHidden = true
            AppConstants.shared.refreshData()
            initialViewController = ControllerHelper.homeVC(nav: self.navigationController!)
        }
        self.navigationController?.setViewControllers([initialViewController], animated: true)
    }
    @objc func navigateToLogin() {
        self.navigationController?.setViewControllers([
            ControllerHelper.getStartedVC(nav: self.navigationController!),
        ], animated: true)
    }
    
    @objc func updateProgress(notification: Notification) {
        if let progress = notification.object as? Progress {
            progressView.progress = Float(progress.fractionCompleted)
        }
    }
    
    

}
