//
//  PopularMovieOperation.swift
//  Movie Collection
//
//  Created by Deepal Patel on 13/01/19.
//  Copyright © 2019 Deepal Patel. All rights reserved.
//

import UIKit

class PopularMovieOperation: DownloadOperation {

    override init() {
        super.init()
        self.type = .moviePoularity
    }
    
    override func parse(data: Data) {
        self.result = data
    }
}
