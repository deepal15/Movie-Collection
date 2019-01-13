//
//  TextPresentable.swift
//  Movie Collection
//
//  Created by Deepal Patel on 13/01/19.
//  Copyright © 2019 Deepal Patel. All rights reserved.
//

import UIKit

protocol TextPresentable {
    
    var text: String { get }
    var textColor: UIColor { get }
    var font: UIFont { get }
}

extension TextPresentable {
    
    var textColor: UIColor {
        return .black
    }
    
    var font: UIFont {
        return .systemFont(ofSize: 17)
    }
}
