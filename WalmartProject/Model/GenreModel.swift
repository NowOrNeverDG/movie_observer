//
//  GenreModel.swift
//  WalmartProject
//
//  Created by Ge Ding on 7/22/21.
//

import Foundation

struct Genres: Codable, Returnable {
    let genres: [Genre]
}


struct Genre: Codable {
    let id: Int?
    let name: String?
}

