//
//  URLManager.swift
//  Movie Collection
//
//  Created by Deepal Patel on 13/01/19.
//  Copyright © 2019 Deepal Patel. All rights reserved.
//

import Foundation

class URLManager: NSObject {

    
    class var manager: URLManager {
        struct Static {
            static let instance = URLManager()
        }
        return Static.instance
    }
    
    internal func searchMovie(name: String) -> URL {
        
        var urlComponents = URLComponents(string: kURL.searchURL)!
        urlComponents.queryItems = [URLQueryItem(name: "api_key", value: kAPI.key),
                                    URLQueryItem(name: "query", value: name)]
        return urlComponents.url!
    }
    
    internal func popularMovie(page: String) -> URL {
        
        var urlComponents = URLComponents(string: kURL.popularURL)!
        urlComponents.queryItems = [URLQueryItem(name: "api_key", value: kAPI.key),
                                    URLQueryItem(name: "page", value: page),
                                    URLQueryItem(name: "language", value: "en-US")]
        return urlComponents.url!
    }
    
    internal func topRatedMovie(page: String) -> URL {
        
        var urlComponents = URLComponents(string: kURL.topRatedURL)!
        urlComponents.queryItems = [URLQueryItem(name: "api_key", value: kAPI.key),
                                    URLQueryItem(name: "page", value: page),
                                    URLQueryItem(name: "language", value: "en-US")]
        return urlComponents.url!
    }
    
    
    
}
