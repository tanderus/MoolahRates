//
//  Coordinator.swift
//  HomeScreen
//
//  Created by Pavel Krasnobrovkin on 01/05/2019.
//  Copyright © 2019 Pavel Krasnobrovkin. All rights reserved.
//

import UIKit

public final class Coordinator {
    
    public init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
        
        let bundle = Bundle(for: HomeScreen.Coordinator.self)
        let storyboard = UIStoryboard(name: "Main", bundle: bundle)
        let identifier = String(describing: HomeViewController.self)
        let viewController = storyboard.instantiateViewController(withIdentifier: identifier) as! HomeViewController
        self.viewController = viewController
    }
    
    public func start() {
        self.navigationController.setViewControllers([self.viewController], animated: false)
    }
    
    internal let navigationController: UINavigationController
    internal let viewController: UIViewController
}
