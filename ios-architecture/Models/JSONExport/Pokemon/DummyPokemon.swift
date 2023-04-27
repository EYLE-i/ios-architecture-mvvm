//
//  Pokemon.swift
//  ios-architecture
//
//  Created by AIR on 2023/04/17.
//

import Foundation

struct DummyPokemonListResponse: Decodable {
    var count: Int
    var next: String?
    var previous: String?
    var results: [DummyPokemonResult]
}

struct DummyPokemonResult: Decodable {
    var name: String
    var url: String
}

struct DummyPokemonList {
    let count: Int
    let pokemons: [DummyPokemon]
    
    init(_ response: DummyPokemonListResponse) {
        self.count = response.count
        self.pokemons = response.results.map { DummyPokemon($0) }
    }
}

struct DummyPokemon {
    let name: String
    let number: Int
    let imageUrl: URL?
    var isFavorite: Bool
    
    init(_ resource: DummyPokemonResult) {
        self.name = resource.name
        self.number = generatePokemonNumber(resource.url)
        self.imageUrl = generatePokemonImageUrl(self.number)
        self.isFavorite = false
    }
}
