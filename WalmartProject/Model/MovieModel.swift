//
//  MovieModel.swift
//  WalmartProject
//
//  Created by Ge Ding on 7/21/21.
//

import Foundation

protocol Returnable {}


struct Movies: Codable, Returnable {
    let results: [Movie]
}

struct Movie: Codable, Returnable {
    let title: String?
    let popularity: Double?
    let release_date: String?
    let poster_path: String?
    let genre_ids: [Int]?
    let mainGenre: Genre?
    let id: Int?
    var overview: String? = nil
    var runtime: Int? = nil
    var homepage: String? = nil
}

