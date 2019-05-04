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

final class SelectCurrencyViewController: UIViewController, StoryboardInstantiatable {

    var afterViewDidLoad: (() -> Void)!
    
    @IBOutlet internal weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.afterViewDidLoad()
    }
}
