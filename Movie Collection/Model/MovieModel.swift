//
//  MovieModel.swift
//  Movie Collection
//
//  Created by Deepal Patel on 13/01/19.
//  Copyright © 2019 Deepal Patel. All rights reserved.
//

import Foundation


struct MovieList: Codable {
    
    let vote_count: Int
    let id: Int
    let video: Bool
    let vote_average: Double
    let title: String
    let popularity: Double
    let poster_path: String
    let original_language: String
    let original_title: String
    let genre_ids: [Int]
    let backdrop_path: String
    let adult: Bool
    let overview: String
    let release_date: String
    
    init(vote_count: Int,
         id: Int,
         video: Bool,
         vote_average: Double,
         title: String,
        popularity: Double,
        poster_path: String,
        original_language: String,
        original_title: String,
        genre_ids:[Int],
        backdrop_path: String,
        adult: Bool,
        overview: String,
        release_date: String
         ) {
        
        self.vote_count = vote_count
        self.id = id
        self.video = video
        self.vote_average = vote_average
        self.title = title
        self.popularity = popularity
        self.poster_path = poster_path
        self.original_language = original_language
        self.original_title = original_title
        self.genre_ids = genre_ids
        self.backdrop_path = backdrop_path
        self.adult = adult
        self.overview = overview
        self.release_date = release_date
    }
}

struct MovieModel: Codable {
    
    
    
    let page: Int
    let total_results: Int
    let total_pages: Int
    let results: [MovieList]
    
    init(page: Int, total_results: Int, total_pages: Int, results: [MovieList]) {
        self.page = page
        self.total_results = total_results
        self.total_pages = total_pages
        self.results = results
    }
}
