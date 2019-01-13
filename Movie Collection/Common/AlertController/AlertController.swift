//
//  File.swift
//  Movie Collection
//
//  Created by Deepal Patel on 13/01/19.
//  Copyright © 2019 Deepal Patel. All rights reserved.
//

import UIKit


class AlertController: NSObject {
    
    typealias successBlock = (() -> Void)?
    typealias failureBlock = (() -> Void)?
    
    
    class var shared: AlertController {
        struct Static {
            static let instance = AlertController()
        }; return Static.instance
    }
    
    func showAlert(title titleName: String?, message: String?, delegate: UIViewController, complete: successBlock) {
        
        let controller = UIAlertController.init(title: titleName, message: message, preferredStyle: .actionSheet)
        let action = UIAlertAction.init(title: "Okay", style: .default) { (alertAction) in
            complete?()
        }
        
        controller.addAction(action)
        
        if #available(iOS 10.0, *) {
            DispatchQueue.main.async {
                delegate.present(controller, animated: true, completion: nil)
            }
        }
        else {
            DispatchQueue.main.async {
                delegate.present(controller, animated: true, completion: nil)
            }
        }
    }
}

