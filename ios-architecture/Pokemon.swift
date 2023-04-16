//
//  Pokemon.swift
//  ios-architecture
//
//  Created by AIR on 2023/04/17.
//

import Foundation

struct PokemonList: Decodable {
    var count: Int
    var next: String?
    var previous: String?
    var results: [PokemonResult]
}

struct PokemonResult: Decodable {
    var name: String
    var url: String
}
