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
        
        let todoListViewController = TodoListViewController()
        
        // Dependency injection.
        todoListViewController.todoProvider = TodoManager()
        
        window.rootViewController = UINavigationController(rootViewController: todoListViewController)
        
        window.makeKeyAndVisible()
        
        return true
            
    }
    
}
