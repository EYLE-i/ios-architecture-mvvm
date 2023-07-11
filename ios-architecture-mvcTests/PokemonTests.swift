//
//  PokemonTests.swift
//  ios-architecture-mvcTests
//
//  Created by AIR on 2023/07/11.
//

import XCTest
@testable import ios_architecture_mvc

final class PokemonTests: XCTestCase {
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testPokemonInitialization() {
        let result = PokemonResult(name: "Pikachu", url: "https://pokeapi.co/api/v2/pokemon/25/")
        let pokemon = Pokemon(result)
        
        XCTAssertEqual(pokemon.name, "Pikachu")
        XCTAssertEqual(pokemon.number, 25)
        XCTAssertEqual(pokemon.imageUrl, URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/25.png"))
    }
    
    func testGeneratePokemonNumber() {
        let url1 = "https://pokeapi.co/api/v2/pokemon/123/"
        let url2 = "https://pokeapi.co/api/v2/pokemon/abc/"
        let url3 = "https://pokeapi.co/api/v2/pokemon/"
        
        XCTAssertEqual(generatePokemonNumber(url1), 123)
        XCTAssertEqual(generatePokemonNumber(url2), 0)
        XCTAssertEqual(generatePokemonNumber(url3), 0)
    }
    
    func testGeneratePokemonImageUrl() {
        let imageUrl1 = generatePokemonImageUrl(25)
        
        XCTAssertEqual(imageUrl1, URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/25.png"))
    }
}
