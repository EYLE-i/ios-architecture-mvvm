//
//  Pokemon.swift
//  ios-architecture-mvc
//
//  Created by AIR on 2023/04/26.
//

import Foundation

struct Pokemon {
    let name: String
    let number: Int
    let imageUrl: URL?
    
    init(_ result: PokemonResult) {
        self.name = result.name
        self.number = generatePokemonNumber(result.url)
        self.imageUrl = generatePokemonImageUrl(self.number)
    }
}

struct PokemonResult: Decodable {
    let name: String
    var url: String
}

struct PokemonResponse: Decodable {
    let count: Int
    let next: String?
    let previous: String?
    let results: [PokemonResult]
}

func generatePokemonNumber(_ url: String) -> Int {
    var removePrefix = url.replacingOccurrences(
        of: "https://pokeapi.co/api/v2/pokemon/", with: ""
    )
    if !removePrefix.isEmpty {
        removePrefix.removeLast()
    }
    return Int(removePrefix) ?? 0
}

func generatePokemonImageUrl(_ no: Int) -> URL? {
    let strNo = String(no)
    let imageUrl = "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/\(strNo).png"
    return URL(string: imageUrl)
}
