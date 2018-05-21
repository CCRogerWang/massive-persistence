//
//  AppDelegate.swift
//  Demo
//
//  Created by Roy Hsu on 2018/5/21.
//  Copyright © 2018 TinyWorld. All rights reserved.
//

// MARK: - AppDelegate

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder {
    
    let window = UIWindow(frame: UIScreen.main.bounds)
    
}

// MARK: - UIApplicationDelegate

extension AppDelegate: UIApplicationDelegate {
    
    public final func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?
    )
    -> Bool {
        
        window.rootViewController = UINavigationController(
            rootViewController: TodoListViewController()
        )
        
        window.makeKeyAndVisible()
        
        return true
            
    }
    
}
