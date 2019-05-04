//
//  StoryboardInstantiatable.swift
//  StoryboardInstantiatable
//
//  Created by Pavel Krasnobrovkin on 01/05/2019.
//  Copyright © 2019 Pavel Krasnobrovkin. All rights reserved.
//

import UIKit

public protocol StoryboardInstantiatable: UIViewController {
    
    static func instantiateViaStoryboard() -> Self
}

public extension StoryboardInstantiatable {
    
    static var storyboardName: String {
        return "Main"
    }
    
    static var identifierInStoryboard: String {
        return String(describing: Self.self)
    }
    
    static func instantiateViaStoryboard() -> Self {
        let bundle = Bundle(for: Self.self)
        let storyboard = UIStoryboard(name: self.storyboardName, bundle: bundle)
        return storyboard.instantiateViewController(withIdentifier: identifierInStoryboard) as! Self
    }
}
