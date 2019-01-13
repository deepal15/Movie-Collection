//
//  ReusableCellIdentifier.swift
//  Movie Collection
//
//  Created by Deepal Patel on 13/01/19.
//  Copyright © 2019 Deepal Patel. All rights reserved.
//

import Foundation


protocol ReusableCellIdentifier {
    static var reuseIdentifier: String { get }
}

extension ReusableCellIdentifier {
    
    static var reuseIdentifier: String {
        return "\(self)"
    }
}
