//
//  HomeViewController.swift
//  HomeScreen
//
//  Created by Pavel Krasnobrovkin on 01/05/2019.
//  Copyright © 2019 Pavel Krasnobrovkin. All rights reserved.
//

import UIKit
import StoryboardInstantiatable

internal final class HomeViewController: UIViewController, StoryboardInstantiatable {
    
    var afterViewDidLoad: (() -> Void)!
    
    @IBOutlet internal weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.afterViewDidLoad()
    }
}
