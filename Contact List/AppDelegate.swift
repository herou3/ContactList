//
//  AppDelegate.swift
//  Contact List

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var coordinator: ContactsListCoordinator!

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.makeKeyAndVisible()
        self.window?.rootViewController = UINavigationController(nibName: nil, bundle: nil)
        guard let navigationController = window?.rootViewController as? UINavigationController else { return true }
        coordinator = ContactsListCoordinator(navigationController: navigationController)
        coordinator.start()
        return true
    }
}
