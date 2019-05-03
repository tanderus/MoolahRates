//
//  Coordinator.swift
//  CalculatorScreen
//
//  Created by Pavel Krasnobrovkin on 03/05/2019.
//  Copyright © 2019 Pavel Krasnobrovkin. All rights reserved.
//

import UIKit

public final class Coordinator {
    
    public init(_ baseViewController: UINavigationController) {
        self.baseViewController = baseViewController
        
        let viewController = CalculatorViewController.instantiateViaStoryboard()
        self.viewController = viewController
    }
    
    public func start() {
        self.baseViewController.present(self.viewController, animated: true, completion: nil)
    }
    
    internal let baseViewController: UIViewController
    internal let viewController: CalculatorViewController
}
