//
//  DownloadOperation.swift
//  Movie Collection
//
//  Created by Deepal Patel on 13/01/19.
//  Copyright © 2019 Deepal Patel. All rights reserved.
//

import Foundation
import UIKit

protocol DownloadOperationDelegate {
    
    func operationDidBegin() -> Void
    func operationDidFail(operation: Operation) -> Void
    func operationDidCanceled(operation: Operation) -> Void
    func operationDidFinish(operation: Operation) -> Void
    
}


class DownloadOperation: Operation {
    
    enum DownloadOperationType {
        case movieRating
        case moviePoularity
        case searchMovie
    }
    
    
    var url: URL?
    var result: Data?
    var delegate: DownloadOperationDelegate?
    var error: Error?
    
    var type: DownloadOperationType!
    
    override func main() {
        
        self.createBody()
    }
    
    
    //MARK: - Override method in child class
    
    func parse(data: Data) -> Void {
        
        
    }
    
    
    func createBody() {
        
        if (self.isCancelled) {
            self.operationDidCancelled()
            return;
        }
        
        self.operationDidBegin()
        
        guard let url = url else { return }
        
        let request = URLRequest.init(url: url)
        let configuration = URLSession.shared.configuration
        configuration.timeoutIntervalForRequest = 15
        configuration.timeoutIntervalForResource = 15
        
        let task = URLSession.init(configuration: configuration).dataTask(with: request) { (data, response, error) -> Void in
            
            if let data = data {
                self.parse(data: data)
                self.operationDidFinish()
            }
            else {
                if let error = error { self.operationDidFail(error: error) }
            }
        }; task.resume()
    }
    
    //MARK: - internal functions
    
    func operationDidBegin() -> Void {
        
        if let delegate = self.delegate { delegate.operationDidBegin() }
    }
    
    func operationDidFail(error: Error) -> Void {
        
        if let delegate = self.delegate { delegate.operationDidFail(operation: self) }
        AlertController.shared.showAlert(title: error.localizedDescription, message: "", delegate: self.delegate as! UIViewController
            , complete: nil)
    }
    
    func operationDidCancelled() -> Void {
        
        DispatchQueue.main.async {
            if let delegate = self.delegate { delegate.operationDidCanceled(operation: self) }
        }
    }
    
    func operationDidFinish() -> Void {
        
        if let delegate = self.delegate { delegate.operationDidFinish(operation: self) }
    }
}
