//
//  Coordinator.swift
//  HomeScreen
//
//  Created by Pavel Krasnobrovkin on 01/05/2019.
//  Copyright © 2019 Pavel Krasnobrovkin. All rights reserved.
//

import UIKit
import StoryboardInstantiatable

import CurrencyRate
import DatabaseService
import BackendService

import SelectCurrencyPairFlow
import MBProgressHUD

public final class Coordinator {
    
    public init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
        
        let viewController = HomeViewController.instantiateViaStoryboard()
        self.viewController = viewController
        
    }
    
    public func start() {
        self.database.initialize { [weak self] result in
            switch result {
            case let .failure(error):
                self?.processDatabaseInitError(error)
                
            case let .success(initialRatesSorted):
                self?.processDatabaseInitSuccess(initialRatesSorted)
            }
        }
    }
    
    private func processDatabaseInitError(_ error: DatabaseError) {
        let title = "Oops. Something went wrong"
        let message: String
        switch error {
        case .InternalError:
            message = "Unknow error while initializing database"
            
        case let .NotEnoughDiskSpace(requiredDiskSpaceBytes):
            message = "Not enough disk space. Required \(requiredDiskSpaceBytes / 1024 / 1024) MB"
        }
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "Ok, crash the app", style: .default) { _ in
            fatalError("Intentional crash")
        }
        alert.addAction(ok)
        
        self.navigationController.present(alert, animated: true, completion: nil)
    }
    
    private func processDatabaseInitSuccess(_ rates: [CurrencyRate]) {
        self.ratesUpdater = RatesUpdater(self.database, backend: self.backend)
        self.presenter = PresenterImplementation(
            rates
            , didRequestAddRate: self.didRequestAddRate
            , didSelectRate: self.didSelectRate
            , didRequestToDeleteRate: self.didRequestToDeleteRate
        )
        
        self.viewController.afterViewDidLoad = { [weak self] in
            guard let self = self else {
                return
            }
            
            self.presenter.showRowsOn(self.viewController.tableView!)
            self.presenter.observeDatabase(self.database)
            self.ratesUpdater.startUpdatingRates()
        }
        
        self.navigationController.setViewControllers([self.viewController], animated: false)
    }
    
    private func didRequestAddRate() {
        
        let pairs = self.database.latestRatesSorted.map { $0.currencyPair }
        self.newRateCoordinator = SelectCurrencyPairFlow.Coordinator(self.navigationController, alreadyUsedPairs: Set(pairs))
        self.newRateCoordinator.didSelectCurrencyPair = self.didSelectNewCurrencyPair
        self.newRateCoordinator.start()
    }
    
    private func didSelectRate(_ rate: CurrencyRate) {
        // TODO: Show calculator screen
        print("Selected rate: \(rate.currencyPair)")
    }
    
    private func didRequestToDeleteRate(_ rate: CurrencyRate) {
        self.database.deleteRate(rate) { _ in }
    }
    
    private func didSelectNewCurrencyPair(_ pair: RateCurrencyPair) {
        self.navigationController.dismiss(animated: true) {
            self.newRateCoordinator = nil
            
            let hud = MBProgressHUD.showAdded(to: self.viewController.view, animated: true)
            hud.label.text = "Loading. Please, wait"
            hud.mode = .indeterminate
            hud.removeFromSuperViewOnHide = true
            
            self.backend.downloadLatestRatesForPairs(currencyPairs: [pair], endpoint: .RATES_IO) { [weak self] result in
                hud.hide(animated: true)
                
                switch result {
                
                case let .success(rates):
                    guard let rate = rates.first else {
                        fallthrough
                    }
                    
                    self?.database.createNewRate(rate) { [weak self] result in
                        switch result {
                        case .failure:
                            self?.showFailedToCreateNewRateAlert()
                        case .success:
                            break
                        }
                    }
                    
                case .failure:
                    self?.showFailedToCreateNewRateAlert()
                }
            }
        }
    }
    
    private func showFailedToCreateNewRateAlert() {
        let alert = UIAlertController(title: "Oops. Something went wrong", message: "Failed to create rate", preferredStyle: .alert)
        let ok = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(ok)
        self.navigationController.present(alert, animated: true, completion: nil)
    }
    
    internal let navigationController: UINavigationController
    internal let viewController: HomeViewController
    
    internal var ratesUpdater: RatesUpdater!
    internal var presenter: PresenterImplementation!
    
    internal let database = createNewDatabaseService()
    internal let backend = CreateNewBackendInstance()
    
    private var newRateCoordinator: SelectCurrencyPairFlow.Coordinator!
}
