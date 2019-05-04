//
//  PresenterImplementation.swift
//  HomeScreen
//
//  Created by Pavel Krasnobrovkin on 04/05/2019.
//  Copyright © 2019 Pavel Krasnobrovkin. All rights reserved.
//

import UIKit

import CurrencyRate
import DatabaseService

final class PresenterImplementation: NSObject {
    
    private var ratesSorted: [CurrencyRate]
    private let didRequestAddRate: () -> Void
    private let didSelectRate: (CurrencyRate) -> Void
    private let didRequestToDeleteRate: (CurrencyRate) -> Void
    
    private weak var tableView: UITableView?
    
    init(_ ratesSorted: [CurrencyRate]
        , didRequestAddRate: @escaping () -> Void
        , didSelectRate: @escaping (CurrencyRate) -> Void
        , didRequestToDeleteRate: @escaping (CurrencyRate) -> Void
        ) {
        
        self.ratesSorted = ratesSorted
        self.didRequestAddRate = didRequestAddRate
        self.didSelectRate = didSelectRate
        self.didRequestToDeleteRate = didRequestToDeleteRate
        super.init()
    }
    
    override init() {
        fatalError("Not Supported")
    }
    
    func showRowsOn(_ tableView: UITableView) {
        self.tableView = tableView
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    func observeDatabase(_ database: DatabaseService) {
        database.addObserver(self)
    }
    
    fileprivate func isAddRatesCellAt(_ indexPath: IndexPath) -> Bool {
        return indexPath.row == 0
    }
    
    fileprivate func isCurrencyRateCellAt(_ indexPath: IndexPath) -> Bool {
        return !self.isAddRatesCellAt(indexPath)
    }
}

// MARK: -
// MARK: UITableViewDataSource
extension PresenterImplementation: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1 + self.ratesSorted.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if self.isAddRatesCellAt(indexPath) {
            let id = String(describing: AddCurrencyPairCell.self)
            return tableView.dequeueReusableCell(withIdentifier: id, for: indexPath)
        }
        
        let id = String(describing: ExchangeRateCell.self)
        let cell = tableView.dequeueReusableCell(withIdentifier: id, for: indexPath) as! ExchangeRateCell
        
        let rate = self.rateAtIndexPath(indexPath)
        cell.configureWithRate(rate)
        return cell
    }
    
    private func rateAtIndexPath(_ indexPath: IndexPath) -> CurrencyRate {
        assert(indexPath.row > 0, "Non-zero indexPath.row required")
        return self.ratesSorted[indexPath.row - 1]
    }
}

// MARK: -
// MARK: UITableViewDelegate
extension PresenterImplementation: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if self.isAddRatesCellAt(indexPath) {
            self.didRequestAddRate()
            return
        }
        if self.isCurrencyRateCellAt(indexPath) {
            let rate = self.rateAtIndexPath(indexPath)
            self.didSelectRate(rate)
            return
        }
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        if self.isCurrencyRateCellAt(indexPath) {
            return .delete
        }
        
        return .none
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        guard self.isCurrencyRateCellAt(indexPath) else {
            return
        }
        
        guard editingStyle == .delete else {
            return
        }
        
        let rate = self.rateAtIndexPath(indexPath)
        self.didRequestToDeleteRate(rate)
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.heightForRowAt(indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.heightForRowAt(indexPath)
    }
    
    private func heightForRowAt(_ indexPath: IndexPath) -> CGFloat {
        if self.isAddRatesCellAt(indexPath) {
            return 60
        }
        
        return 50
    }
}


// MARK: -
// MARK: DatabaseObserver
extension PresenterImplementation: DatabaseObserver {
    
    func database(_ database: DatabaseService, didCreateRate rate: CurrencyRate) {
        guard let tableView = self.tableView else {
            return
        }
        
        self.ratesSorted.append(rate)
        
        let index = self.ratesSorted.count
        let indexPath = IndexPath(row: index, section: 0)
        tableView.insertRows(at: [indexPath], with: .automatic)
        let visibleIndexPaths = tableView.indexPathsForVisibleRows ?? []
        if !visibleIndexPaths.contains(indexPath) {
            tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
    }
    
    func database(_ database: DatabaseService, didChangeRateTo newRate: CurrencyRate) {
        guard let tableView = self.tableView else {
            return
        }
        
        guard let index = self.ratesSorted.firstIndex(where: { $0.currencyPair == newRate.currencyPair }) else {
            return
        }
        
        let indexPath = IndexPath(row: index + 1, section: 0)
        
        let visibleIndexPaths = tableView.indexPathsForVisibleRows ?? []
        guard visibleIndexPaths.contains(indexPath) else {
            return
        }
        
        guard let cell = tableView.cellForRow(at: indexPath) as? ExchangeRateCell else {
            return
        }
        
        cell.configureWithRate(newRate)
    }
    
    func database(_ database: DatabaseService, didDeleteRate rate: CurrencyRate) {
        guard let tableView = self.tableView else {
            return
        }
        
        guard let index = self.ratesSorted.firstIndex(where: { $0.currencyPair == rate.currencyPair }) else {
            return
        }
        
        self.ratesSorted.remove(at: index)
        tableView.deleteRows(at: [IndexPath(row: index + 1, section: 0)], with: .automatic)
    }
}
