//
//  SelectCurrencyViewController.swift
//  SelectCurrencyScreen
//
//  Created by Pavel Krasnobrovkin on 03/05/2019.
//  Copyright © 2019 Pavel Krasnobrovkin. All rights reserved.
//

import UIKit
import CurrencyCode
import StoryboardInstantiatable

final class SelectCurrencyViewController: UITableViewController, StoryboardInstantiatable {

    var didSelectCurrency: ((CurrencyCode) -> Void)!
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CurrencyCode.allCases.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let id = String(describing: CurrencyCell.self)
        let cell = tableView.dequeueReusableCell(withIdentifier: id, for: indexPath) as! CurrencyCell
        
        let currency = CurrencyCode.allCases[indexPath.row]
        let code = currency.rawValue
        let bundle = Bundle(for: SelectCurrencyViewController.self)
        let image = UIImage(named: code, in: bundle, compatibleWith: nil)!
        cell.configureWithCurrencyName(currency.localizedName, countryFlag: image)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let currency = CurrencyCode.allCases[indexPath.row]
        self.didSelectCurrency(currency)
    }
}
