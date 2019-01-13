//
//  Theme.swift
//  Movie Collection
//
//  Created by Deepal Patel on 13/01/19.
//  Copyright © 2019 Deepal Patel. All rights reserved.
//

import UIKit


let ThemeDidChangeNotification = Notification.Name("ThemeDidChangeNotification")

protocol ThemeConformable {
    func setThemeColor() -> Swift.Void
}

internal class Theme {
    
    internal class var sharedInstance: Theme {
        struct shared {
            static let instance = Theme()
        }; return shared.instance
    }
    
    internal var barTintColor: UIColor {
        return UIColor.white
    }
    
    @objc
    fileprivate func changeTheme() -> Swift.Void {
        
        NotificationCenter.default.post(name: ThemeDidChangeNotification, object: nil)
    }
    
}
