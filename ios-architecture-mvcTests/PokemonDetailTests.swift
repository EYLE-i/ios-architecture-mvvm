//
//  PokemonDetailTests.swift
//  ios-architecture-mvcTests
//
//  Created by AIR on 2023/07/17.
//

import XCTest
@testable import ios_architecture_mvc

final class PokemonDetailTests: XCTestCase {
    
    func test_PokemonDetailInitialization() {
        let number = 25
        let imageUrl = URL(string: "https://example.com/pikachu.png")!
        let response = PokemonDetailResponse(name: "Pikachu", height: 40, weight: 60)
        
        let pokemonDetail = PokemonDetail(number: number, imageUrl: imageUrl, response: response)
        
        XCTAssertEqual(pokemonDetail.number, number)
        XCTAssertEqual(pokemonDetail.name, response.name)
        XCTAssertEqual(pokemonDetail.height, response.height)
        XCTAssertEqual(pokemonDetail.weight, response.weight)
        XCTAssertEqual(pokemonDetail.imageUrl, imageUrl)
    }
    
}
