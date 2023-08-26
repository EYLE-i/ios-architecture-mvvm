//
//  ios_architecture_mvpTests.swift
//  ios-architecture-mvpTests
//
//  Created by AIR on 2023/06/07.
//

import XCTest
@testable import ios_architecture_mvp

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
    
    func requestPokemonList(completion: @escaping (Result<[Pokemon], APIError>) -> Void) {
        completion(requestResult)
        switch requestResult {
        case .success:
            returnPokemons = mockPokemons
        default:
            returnPokemons = nil
        }
    }
}

final class ios_architecture_mvpTests: XCTestCase {
    private var mockPokemonListAPI: MockPokemonListAPI!
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func test_成功pokemonListを返す() throws {
        mockPokemonListAPI = MockPokemonListAPI()
        let expectation = expectation(description: "")
        
        mockPokemonListAPI.requestPokemonList { result in
            switch result {
            case .success(let pokemonList):
                XCTAssertEqual(pokemonList[0].name, "name0")
                XCTAssertEqual(pokemonList[0].number, 0)
                XCTAssertEqual(pokemonList[0].imageUrl, URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/0.png"))
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
