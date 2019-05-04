//
//  Presenter.swift
//  SelectCurrencyScreen
//
//  Created by Pavel Krasnobrovkin on 04/05/2019.
//  Copyright © 2019 Pavel Krasnobrovkin. All rights reserved.
//

import UIKit

import CurrencyCode

class Presenter: NSObject {
    
    var didSelectCurrency: ((CurrencyCode) -> Void)!
    
    override init() {
        fatalError("Use init(disabledCurrency:) instead")
    }
    
    init(_ disabledCurrency: Set<CurrencyCode>) {
        self.disabledCurrency = disabledCurrency
        
        let all = CurrencyCode.allCases
        let enabledSorted = all.filter { !disabledCurrency.contains($0) }
        let disabledSorted = all.filter { disabledCurrency.contains($0) }
        
        self.allCurrenciesSorted = enabledSorted + disabledSorted
        super.init()
    }
    
    func showCurrenciesOn(_ tableView: UITableView) {
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    fileprivate let disabledCurrency: Set<CurrencyCode>
    fileprivate let allCurrenciesSorted: [CurrencyCode]
}

// MARK: -
// MARK: UITableViewDataSource
extension Presenter: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.allCurrenciesSorted.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let id = String(describing: CurrencyCell.self)
        let cell = tableView.dequeueReusableCell(withIdentifier: id, for: indexPath) as! CurrencyCell
        
        let code = self.allCurrenciesSorted[indexPath.row]
        let flag = UIImage(named: "\(code)", in: Bundle(for: CurrencyCell.self), compatibleWith: nil)!
        cell.configureWithCurrencyName(
            code.localizedName
            , countryFlag: flag
            , isDisabled: self.disabledCurrency.contains(code)
        )
        return cell
    }
}

// MARK: -
// MARK: UITableViewDelegate
extension Presenter: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let code = self.allCurrenciesSorted[indexPath.row]
        guard !isCurrencyDisabledAt(indexPath) else {
            return
        }
        
        self.didSelectCurrency(code)
    }
    
    fileprivate func isCurrencyDisabledAt(_ indexPath: IndexPath) -> Bool {
        let code = self.allCurrenciesSorted[indexPath.row]
        return self.disabledCurrency.contains(code)
    }
}
