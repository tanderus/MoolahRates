//
//  Coordinator.swift
//  SelectCurrencyScreen
//
//  Created by Pavel Krasnobrovkin on 03/05/2019.
//  Copyright © 2019 Pavel Krasnobrovkin. All rights reserved.
//

import UIKit
import CurrencyCode
import StoryboardInstantiatable

public final class Coordinator {
    
    public var didSelectCurrency: ((CurrencyCode) -> Void)!
    
    public init(
        _ navigationController: UINavigationController
        , disabledCurrency: Set<CurrencyCode>
        , shouldPushOnStart: Bool = false
        ) {
        self.navigationController = navigationController
        self.shouldPushOnStart = shouldPushOnStart
        
        let viewController = SelectCurrencyViewController.instantiateViaStoryboard()
        self.viewController = viewController
        
        let presenter = Presenter(disabledCurrency)
        self.presenter = presenter
        
        presenter.didSelectCurrency = { [weak self] code in
            self?.didSelectCurrency(code)
        }
        
        viewController.afterViewDidLoad = { [weak viewController] in
            guard let tableView = viewController?.tableView else {
                return
            }
            
            presenter.showCurrenciesOn(tableView)
        }
    }
    
    public func start() {
        if self.shouldPushOnStart {
            self.navigationController.pushViewController(self.viewController, animated: true)
        }
        else {
            self.navigationController.setViewControllers([self.viewController], animated: false)
        }
    }
    
    internal let navigationController: UINavigationController
    internal let shouldPushOnStart: Bool
    internal let viewController: SelectCurrencyViewController
    internal let presenter: Presenter
}
