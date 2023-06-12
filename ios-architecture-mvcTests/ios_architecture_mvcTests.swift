//
//  ios_architecture_mvcTests.swift
//  ios-architecture-mvcTests
//
//  Created by AIR on 2023/06/07.
//

import XCTest
@testable import ios_architecture_mvc

class MockPokemonListAPI: PokemonListAPIProtocol {
    
    var returnPokemons: [Pokemon]?
    
    lazy var requestResult: Result<[Pokemon], APIError> = .success(mockPokemons)
    
    var mockPokemonResults: [PokemonResult] {
        var pokemonResults = [PokemonResult]()
        for i in 0...10 {
            let name = "name\(i)"
            let url = "https://pokeapi.co/api/v2/pokemon/\(i)/"
            pokemonResults.append(PokemonResult(name: name, url: url))
        }
        return pokemonResults
    }
    
    var mockPokemons: [Pokemon] {
        var pokemons = [Pokemon]()
        for result in mockPokemonResults {
            pokemons.append(Pokemon(result))
        }
        return pokemons
    }
    
    func requestPokemonList(completion: @escaping (Result<[ios_architecture_mvc.Pokemon], ios_architecture_mvc.APIError>) -> Void) {
        completion(requestResult)
        switch requestResult {
        case .success:
            returnPokemons = mockPokemons
        default:
            returnPokemons = nil
        }
    }
}

final class ios_architecture_mvcTests: XCTestCase {
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testExample() throws {
        let mockAPI = MockPokemonListAPI()
        let expectation = expectation(description: "")
        
        mockAPI.requestPokemonList { result in
            switch result {
            case .success(let pokemon):
                XCTAssertEqual(pokemon[0].name, "name0")
                XCTAssertEqual(pokemon[1].number, 1)
                expectation.fulfill()
            default:
                print("default")
            }
        }
        
        wait(for: [expectation], timeout: 5)
    }
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
