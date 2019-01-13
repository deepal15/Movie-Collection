//
//  ViewController.swift
//  Movie Collection
//
//  Created by Deepal Patel on 13/01/19.
//  Copyright © 2019 Deepal Patel. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    var downloadOperation: DownloadOperation!
    weak var pendingRquest: DispatchWorkItem?
    
    @IBOutlet fileprivate var searchBar: UISearchBar!
    @IBOutlet fileprivate var btnFilter: UIBarButtonItem!
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    var data: MovieModel?
    
    //MARK: - UIView
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.btnFilter.target = self
        self.btnFilter.action = #selector(filter)
        
        self.searchBar.delegate = self
        
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        
        let collectionViewLayout = self.collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        collectionViewLayout.itemSize = UICollectionViewFlowLayout.automaticSize
        collectionViewLayout.estimatedItemSize = CGSize(width: 150, height: 60)
    }
    
    @objc
    fileprivate func filter() -> Swift.Void {
        
        let controller = UIAlertController(title: "Select Filter", message: nil, preferredStyle: .actionSheet)
        let popularity = UIAlertAction(title: "Most Popular", style: .default) { (action) in
            
        }
        
        let highRate = UIAlertAction(title: "highest Rated", style: .default) { (action) in
            
        }
        
        let cancel = UIAlertAction(title: "cancel", style: .cancel) { (action) in
            
        }
        
        controller.addAction(popularity)
        controller.addAction(highRate)
        controller.addAction(cancel)
        present(controller, animated: true, completion: nil)
    }
    
    
    //MARK: - Webservice
    
    fileprivate func getMovies(with name: String) -> Swift.Void {
        
        let operation = DownloadManager.manager.createDownloaderForSearchMovie(delegate: self, name: name)
        self.downloadOperation = operation
    }

    
    fileprivate func getTopRatedMovies(page: String = "1") -> Swift.Void {
        
        let operation = DownloadManager.manager.createDownloaderForTopRatedMovie(delegate: self, page: page)
        self.downloadOperation = operation
    }
    
    fileprivate func getPopularMovies(page: String = "1") -> Swift.Void {
        
        let operation = DownloadManager.manager.createDownloaderForPopularMovie(delegate: self, page: page)
        self.downloadOperation = operation
    }
    
    
}

extension HomeViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        let requestItem = DispatchWorkItem { [weak self] in
            
            if let `self` = self {
                
                if let request = self.pendingRquest {
                    
                    if request.isCancelled {
                        request.cancel()
                    }
                }
                else {
                    self.getMovies(with: searchText)
                }
            }
        }
        
        self.pendingRquest = requestItem
        
        DispatchQueue.main.asyncAfter(deadline: .now() +  0.5, execute: requestItem)
    }
}

extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let data = self.data else { return 0 }
        return data.results.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CollectionViewCell
//        cell.textLabel.text = data[indexPath.row].name
//
//        let task = URLSession.init(configuration: .default).dataTask(with: data[indexPath.row].imageURL) { (data, response, error) -> Void in
//
//            if let data1 = data {
//                DispatchQueue.main.async { cell.imageView.image = UIImage(data: data1) }
//            }
//        }
//        task.resume()
        return cell
    }
}

extension HomeViewController: DownloadOperationDelegate {
    
    func operationDidBegin() {
        
    }
    
    func operationDidFail(operation: Operation) {
        
    }
    
    func operationDidCanceled(operation: Operation) {
        
    }
    
    func operationDidFinish(operation: Operation) {
        
        if self.downloadOperation == operation && self.downloadOperation.type == .searchMovie {
        
            if let data = self.downloadOperation.result {
                
                do {
                    let decoder = JSONDecoder()
                    let gitData = try decoder.decode(MovieModel.self, from: data)
                    print(gitData.page)
                    
                } catch let err {
                    print("Err", err)
                }
            }
        }
        else if self.downloadOperation == operation && self.downloadOperation.type == .movieRating {
            
            if let data = self.downloadOperation.result {
                
                do {
                    let decoder = JSONDecoder()
                    let gitData = try decoder.decode(MovieModel.self, from: data)
                    print(gitData.page)
                    
                } catch let err {
                    print("Err", err)
                }
            }
        }
        else if self.downloadOperation == operation && self.downloadOperation.type == .moviePoularity {
            
            if let data = self.downloadOperation.result {
                
                do {
                    let decoder = JSONDecoder()
                    let gitData = try decoder.decode(MovieModel.self, from: data)
                    print(gitData.page)
                    
                } catch let err {
                    print("Err", err)
                }
            }
        }
    }
}
