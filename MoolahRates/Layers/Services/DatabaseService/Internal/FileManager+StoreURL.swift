//
//  FileManager+StoreURL.swift
//  DatabaseService
//
//  Created by Pavel Krasnobrovkin on 03/05/2019.
//  Copyright © 2019 Pavel Krasnobrovkin. All rights reserved.
//

import Foundation

extension FileManager {
    
    var storeDirectoryUrl: URL? {
        return self.urls(for: .documentDirectory, in: .userDomainMask).last
    }
}
