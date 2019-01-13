//
//  DownloadManager.swift
//  Movie Collection
//
//  Created by Deepal Patel on 13/01/19.
//  Copyright © 2019 Deepal Patel. All rights reserved.
//

import Foundation

class DownloadManager: NSObject {
    
    var operationQueue = OperationQueue()
    
    class var manager: DownloadManager {
        struct Static {
            static let sharedInstance = DownloadManager()
        };return Static.sharedInstance
    }
    
    func createDownloaderForSearchMovie(delegate: DownloadOperationDelegate, name: String) -> DownloadOperation {
        let operation = SearchMovieOperation()
        operation.url = URLManager.manager.searchMovie(name: name)
        operation.delegate = delegate
        operationQueue.addOperation(operation)
        return operation
    }
    
    
    func createDownloaderForTopRatedMovie(delegate: DownloadOperationDelegate, page: String) -> DownloadOperation {
        let operation = TopRatedMovieOperation()
        operation.url = URLManager.manager.topRatedMovie(page: page)
        operation.delegate = delegate
        operationQueue.addOperation(operation)
        return operation
    }
    
    
    func createDownloaderForPopularMovie(delegate: DownloadOperationDelegate, page: String) -> DownloadOperation {
        let operation = PopularMovieOperation()
        operation.url = URLManager.manager.popularMovie(page: page)
        operation.delegate = delegate
        operationQueue.addOperation(operation)
        return operation
    }
    
}
