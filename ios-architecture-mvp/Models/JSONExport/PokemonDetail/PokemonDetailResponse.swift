//
//  PokemonDetail.swift
//  ios-architecture-mvp
//
//  Created by AIR on 2023/05/09.
//

import Foundation

struct PokemonDetail {
    var number: Int
    var name: String
    var height: Int
    var weight: Int
    var imageUrl: URL?
    
    init(number: Int, imageUrl: URL, response: PokemonDetailResponse) {
        self.number = number
        self.name = response.name
        self.height = response.height
        self.weight = response.weight
        self.imageUrl = imageUrl
    }
}


// MARK: - PokemonDetail
struct PokemonDetailResponse: Decodable {
    var name: String
    var height: Int
    var weight: Int
}
