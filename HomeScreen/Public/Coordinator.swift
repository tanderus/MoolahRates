//
//  Coordinator.swift
//  HomeScreen
//
//  Created by Pavel Krasnobrovkin on 01/05/2019.
//  Copyright © 2019 Pavel Krasnobrovkin. All rights reserved.
//

import UIKit
import StoryboardInstantiatable

public final class Coordinator {
    
    public init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
        
        let viewController = HomeViewController.instantiateViaStoryboard()
        self.viewController = viewController
    }
    
    public func start() {
        self.navigationController.setViewControllers([self.viewController], animated: false)
    }
    
    internal let navigationController: UINavigationController
    internal let viewController: UIViewController
}
