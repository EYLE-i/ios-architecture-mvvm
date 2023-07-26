//
//  PokemonListAPITests.swift
//  ios-architecture-mvcTests
//
//  Created by AIR on 2023/07/25.
//

import XCTest
@testable import ios_architecture_mvc

final class PokemonListAPITests: XCTestCase {
    var mockAPIClient: MockAPIClient!
    var api: PokemonListAPIProtocol!
    
    override func setUp() {
        super.setUp()
        mockAPIClient = MockAPIClient()
        api = PokemonListAPI(apiClient: mockAPIClient)
    }
    
    override func tearDown() {
        mockAPIClient = nil
        api = nil
        super.tearDown()
    }
    
    func test_RequestPokemonListSuccess() {
        let expectation = XCTestExpectation(description: "")
        
        let mockPokemonResponse = PokemonResponse(
            count: 3,
            next: "next",
            previous: "previous",
            results: [
                PokemonResult(name: "Bulbasaur", url: "https://example.com/pokemon/1"),
                PokemonResult(name: "Ivysaur", url: "https://example.com/pokemon/2"),
                PokemonResult(name: "Venusaur", url: "https://example.com/pokemon/3")
            ]
        )
        
        let mockPokemonList: [Pokemon] = [
            Pokemon(PokemonResult(name: "Bulbasaur", url: "https://example.com/pokemon/1")),
            Pokemon(PokemonResult(name: "Ivysaur", url: "https://example.com/pokemon/2")),
            Pokemon(PokemonResult(name: "Venusaur", url: "https://example.com/pokemon/3"))
        ]
        
        mockAPIClient.mockResult = .success(mockPokemonResponse)
        
        api.requestPokemonList { result in
            switch result {
            case .success(let pokemonList):
                XCTAssertEqual(pokemonList, mockPokemonList)
                expectation.fulfill()
            case .failure(let error):
                XCTFail("Pokemon Fail error : \(error)")
            }
        }
        wait(for: [expectation], timeout: 10.0)
    }
    
    func testRequestPokemonListFailure() {
        let expectation = XCTestExpectation(description: "Pokemon list request should fail")
        
        let expectedError = APIError.server(500)
        mockAPIClient.mockResult = .failure(expectedError)
        
        api.requestPokemonList { result in
            switch result {
            case .success:
                XCTFail("Pokemon list request should have failed")
            case .failure(let error):
                XCTAssertEqual(error, expectedError)
                expectation.fulfill()
            }
        }
        
        wait(for: [expectation], timeout: 10.0)
    }
}

extension Pokemon: Equatable {
    public static func == (lhs: Pokemon, rhs: Pokemon) -> Bool {
        return lhs.name == rhs.name && lhs.number == rhs.number && lhs.imageUrl == rhs.imageUrl
    }
}
