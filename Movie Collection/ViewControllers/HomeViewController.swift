//
//  ViewController.swift
//  Movie Collection
//
//  Created by Deepal Patel on 13/01/19.
//  Copyright © 2019 Deepal Patel. All rights reserved.
//

import UIKit
import os.log

class HomeViewController: UIViewController {

    var downloadOperation: DownloadOperation!
    weak var pendingRquest: DispatchWorkItem?
    var loadMore: Bool = false
    var isPopuloarActive = true
    
    @IBOutlet fileprivate var searchBar: UISearchBar!
    @IBOutlet fileprivate var btnFilter: UIBarButtonItem!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var offSet: Int = 1
    
    var data: MovieModel?
    
    //MARK: - UIView
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.btnFilter.target = self
        self.btnFilter.action = #selector(filter)
        
        self.searchBar.delegate = self
        
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        
        self.getPopularMovies(page: String(self.offSet))
        
    }
    
    //MARK: - Filter data
    
    @objc
    fileprivate func filter() -> Swift.Void {
        
        let controller = UIAlertController(title: "Select Filter", message: nil, preferredStyle: .actionSheet)
        let popularity = UIAlertAction(title: "Most Popular", style: .default) { (action) in
            self.data = nil
            DispatchQueue.main.async { self.collectionView.reloadData() }
            self.isPopuloarActive = true
            self.offSet = 1
            self.getPopularMovies(page: String(self.offSet))
        }
        
        let highRate = UIAlertAction(title: "highest Rated", style: .default) { (action) in
            self.data = nil
            DispatchQueue.main.async { self.collectionView.reloadData() }
            self.isPopuloarActive = false
            self.offSet = 1
            self.getPopularMovies(page: String(self.offSet))
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
        
        let logCreate = OSLog.init(subsystem: "com.deepal", category: "URL Request")
        os_log(.debug, log: logCreate, "Name : %@", name)
        
        let operation = DownloadManager.manager.createDownloaderForSearchMovie(delegate: self, name: name)
        self.downloadOperation = operation
    }

    
    fileprivate func getTopRatedMovies(page: String = "1") -> Swift.Void {
        
        let logCreate = OSLog.init(subsystem: "com.deepal", category: "URL Request")
        os_log(.debug, log: logCreate, "Page : %@", page)
        
        let operation = DownloadManager.manager.createDownloaderForTopRatedMovie(delegate: self, page: page)
        self.downloadOperation = operation
        self.loadMore = false
    }
    
    fileprivate func getPopularMovies(page: String = "1") -> Swift.Void {
        
        let logCreate = OSLog.init(subsystem: "com.deepal", category: "URL Request")
        os_log(.debug, log: logCreate, "Page : %@", page)
        
        let operation = DownloadManager.manager.createDownloaderForPopularMovie(delegate: self, page: page)
        self.downloadOperation = operation
        self.loadMore = false
    }
    
    
    
    //MARK: - UINavigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let controller = segue.destination as? DetailViewController,
            segue.identifier == "DetailViewController",
            let element = sender as? MovieList
            else { return }
        controller.data = element
    }
}

extension HomeViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if let request = self.pendingRquest { request.cancel() }
        
        
        let requestItem = DispatchWorkItem { [weak self] in
            
            if let `self` = self {
                self.getMovies(with: searchText)
            }
        }
        
        self.pendingRquest = requestItem
        
        DispatchQueue.main.asyncAfter(deadline: .now() +  .milliseconds(250), execute: requestItem)
    }
}

extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let data = self.data {
            return data.results.count
        }
        else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CollectionViewCell
        
        cell.textLabel.text = data?.results[indexPath.row].title

        let urlMain = String(format: "https://image.tmdb.org/t/p/w500%@", data!.results[indexPath.row].poster_path)
        let url = URL(string: urlMain)!
        let task = URLSession.init(configuration: .default).dataTask(with: url) { (data, response, error) -> Void in

            if let data1 = data {
                DispatchQueue.main.async { cell.imageView.image = UIImage(data: data1) }
            }
        }
        task.resume()
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "DetailViewController", sender: self.data!.results[indexPath.row])
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
    

        if scrollView.bounds.maxY == scrollView.contentSize.height {
            print("@@@@@@@END")
            self.loadMore = true
            self.offSet += 1
            self.doPaging()
        }
        

    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        if indexPath.row == data!.results.count - 1 && !self.loadMore {
            
        }
    }
    
    private func doPaging() {
        print("#####")
        self.loadMore = false
        if self.isPopuloarActive {
            self.getPopularMovies(page: String(self.offSet))
        }
        else {
            self.getTopRatedMovies(page: String(self.offSet))
        }
        
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
                    let data = try decoder.decode(MovieModel.self, from: data)
                    
                    var totalElements: [MovieList] = []
                    
                    if let _ = self.data { self.data = nil }
                    
                    let elements = data.results
                    totalElements.append(contentsOf: elements)
                    let element = MovieModel(page: data.page, total_results: data.total_results, total_pages: data.total_pages, results: totalElements)
                    self.data = element
                    self.loadMore = true
                    DispatchQueue.main.async {
                        self.collectionView.reloadData()
                    }
                    
                } catch let err {
                    print("Err", err)
                }
            }
        }
        else if self.downloadOperation == operation && self.downloadOperation.type == .movieRating {
            
            if let data = self.downloadOperation.result {
                
                do {
                    let decoder = JSONDecoder()
                    let data = try decoder.decode(MovieModel.self, from: data)
                    
                    var totalElements: [MovieList] = []
                    
                    if let previousData = self.data {
                        
                        let elements = previousData.results
                        totalElements.append(contentsOf: elements)
                    }
                    
                    let elements = data.results
                    totalElements.append(contentsOf: elements)
                    let element = MovieModel(page: data.page, total_results: data.total_results, total_pages: data.total_pages, results: totalElements)
                    self.data = element
                    self.loadMore = true
                    DispatchQueue.main.async {
                        self.collectionView.reloadData()
                    }
                    
                } catch let err {
                    print("Err", err)
                }
            }
        }
        else if self.downloadOperation == operation && self.downloadOperation.type == .moviePoularity {
            
            if let data = self.downloadOperation.result {
                
                do {
                    let decoder = JSONDecoder()
                    let data = try decoder.decode(MovieModel.self, from: data)
                    
                    var totalElements: [MovieList] = []
                    
                    if let previousData = self.data {
                        
                        let elements = previousData.results
                        totalElements.append(contentsOf: elements)
                    }
                    
                    let elements = data.results
                    totalElements.append(contentsOf: elements)
                    let element = MovieModel(page: data.page, total_results: data.total_results, total_pages: data.total_pages, results: totalElements)
                    self.data = element
                    self.loadMore = true
                    DispatchQueue.main.async {
                        self.collectionView.reloadData()
                    }
                    
                } catch let err {
                    print("Err", err)
                }
            }
        }
    }
}
