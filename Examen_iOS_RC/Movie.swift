//
//  Movie.swift
//  Examen_iOS_RC
//
//  Created by Mañanas on 24/9/24.
//

import Foundation

struct Movie: Decodable {
    let Title: String
    let Year: String
    let Poster: String
    let imdbID: String
}

struct MovieSearchResponse: Decodable {
    let search: [Movie]
    
    private enum CodingKeys: String, CodingKey {
        case search = "Search"
    }
}
