//
//  AppDelegate.swift
//  OneDataAssessment
//
//  Created by Ajith  on 01/07/24.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var navigationController: UINavigationController?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        //Setting up Root View Controller
        setRootController(DeviceListViewController())
        
        return true
    }
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return .portrait
    }

}

extension AppDelegate{
    
    /// Sets the root view controller of the window.
    /// - Parameter viewController: The view controller to set as root.
    /// - Throws: An error if the window or root view controller couldn't be set up.
    func setRootController(_ viewController: UIViewController){
        window = UIWindow(frame: UIScreen.main.bounds)
        navigationController = UINavigationController(rootViewController: viewController)
        navigationController?.isNavigationBarHidden = true
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
    
}
