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
    
    public init(
        _ navigationController: UINavigationController
        , disabledCurrency: Set<CurrencyCode>
        , didSelectCurrency: @escaping (CurrencyCode) -> Void
        , shouldPushOnStart: Bool = false
        ) {
        self.navigationController = navigationController
        self.shouldPushOnStart = shouldPushOnStart
        
        let viewController = SelectCurrencyViewController.instantiateViaStoryboard()
        self.viewController = viewController
        
        let presenter = Presenter(disabledCurrency)
        presenter.didSelectCurrency = didSelectCurrency
        
        self.presenter = presenter
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
