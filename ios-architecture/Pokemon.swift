//
//  Pokemon.swift
//  ios-architecture
//
//  Created by AIR on 2023/04/17.
//

import Foundation

struct PokemonListResponse: Decodable {
    var count: Int
    var next: String?
    var previous: String?
    var results: [PokemonResult]
}

struct PokemonResult: Decodable {
    var name: String
    var url: String
}

struct PokemonListModel {
    let count: Int
    let pokemons: [Pokemon]
    
    init(_ response: PokemonListResponse) {
        self.count = response.count
        self.pokemons = response.results.map { Pokemon($0) }
    }
}

struct Pokemon {
    let name: String
    let number: Int
    let imageUrl: URL?
    var isFavorite: Bool
    
    init(_ resource: PokemonResult) {
        self.name = resource.name
        self.number = generatePokeNumber(resource.url)
        self.imageUrl = generatePokeImageUrl(self.number)
        self.isFavorite = false
    }
}

func generatePokeNumber(_ url: String) -> Int {
    var removePrefix = url.replacingOccurrences(
        of: "https://pokeapi.co/api/v2/pokemon/", with: ""
    )
    removePrefix.removeLast()
    return Int(removePrefix) ?? 0
}

func generatePokeImageUrl(_ no: Int) -> URL? {
    let strNo = String(no)
    let imageUrl = "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/\(strNo).png"
    return URL(string: imageUrl)
}
