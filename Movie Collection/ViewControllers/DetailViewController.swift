//
//  DetailViewController.swift
//  Movie Collection
//
//  Created by Deepal Patel on 14/01/19.
//  Copyright © 2019 Deepal Patel. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    static let segueIdentifier = "DetailViewController"
    
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblRating: UILabel!
    @IBOutlet weak var lblDescription: UITextView!
    
    var data: MovieList!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let urlMain = String(format: "https://image.tmdb.org/t/p/w500%@", data.poster_path)
        let url = URL(string: urlMain)!
        let task = URLSession.init(configuration: .default).dataTask(with: url) { (data, response, error) -> Void in
            
            if let data1 = data {
                DispatchQueue.main.async { self.image.image = UIImage(data: data1) }
            }
        }
        task.resume()

        DispatchQueue.main.async {
            
            self.lblDate.text = self.data.release_date
            self.lblTitle.text = self.data.title
            self.lblDescription.text = self.data.overview
            self.lblRating.text = String(self.data.vote_average)
        }
    }
    

    

}
