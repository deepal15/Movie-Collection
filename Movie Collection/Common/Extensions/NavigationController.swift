//
//  NavigationController.swift
//  Movie Collection
//
//  Created by Deepal Patel on 13/01/19.
//  Copyright © 2019 Deepal Patel. All rights reserved.
//

import UIKit

class NavigationController: UINavigationController, ThemeConformable {
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        NotificationCenter.default.addObserver(self, selector: #selector(NavigationController.setThemeColor), name: ThemeDidChangeNotification, object: nil)
    }
    
    @objc
    func setThemeColor() {
        
        let instance = Theme.sharedInstance
        navigationBar.barTintColor = instance.barTintColor
    }
}
