//
//  PokemonListModelTests.swift
//  ios-architecture-mvcTests
//
//  Created by AIR on 2023/08/16.
//

import XCTest
@testable import ios_architecture_mvc

final class PokemonListModelTests: XCTestCase {
    
    var userDefaults: UserDefaults!
    var mockDataStore: FavoritePokemonDataStore!
    var mockAPIClient: MockAPIClient!
    var pokemonListModel: PokemonListModel!
    
    override func setUp() {
        super.setUp()
        userDefaults = UserDefaults(suiteName: "PokemonListModelTests")
        mockDataStore = FavoritePokemonDataStoreImpl(userDefaults: userDefaults)
        mockAPIClient = MockAPIClient()
        pokemonListModel = PokemonListModel(dataStore: mockDataStore, apiClient: mockAPIClient)
    }
    
    override func tearDown() {
        userDefaults.removePersistentDomain(forName: "PokemonListModelTests")
        userDefaults = nil
        mockDataStore = nil
        mockAPIClient = nil
        pokemonListModel = nil
        
        super.tearDown()
    }
    
    func testRequestPokemonList_Success() {
        let mockPokemonResponse = PokemonResponse(
            count: 3,
            next: "next",
            previous: "previous",
            results: [
                PokemonResult(name: "Bulbasaur", url: "https://pokeapi.co/api/v2/pokemon/1/"),
                PokemonResult(name: "Ivysaur", url: "https://pokeapi.co/api/v2/pokemon/2/"),
                PokemonResult(name: "Venusaur", url: "https://pokeapi.co/api/v2/pokemon/3/")
            ]
        )
        
        let mockPokemonList: [Pokemon] = [
            Pokemon(PokemonResult(name: "Bulbasaur", url: "https://pokeapi.co/api/v2/pokemon/1/")),
            Pokemon(PokemonResult(name: "Ivysaur", url: "https://pokeapi.co/api/v2/pokemon/2/")),
            Pokemon(PokemonResult(name: "Venusaur", url: "https://pokeapi.co/api/v2/pokemon/3/"))
        ]
        
        mockAPIClient.mockResult = .success(mockPokemonResponse)
        
        var fetchedPokemonList: [Pokemon]?
        var apiError: APIError?
        let expectation = XCTestExpectation(description: "API Request")
        pokemonListModel.requestPokemonList { result in
            switch result {
            case .success(let success):
                fetchedPokemonList = success
            case .failure(let failure):
                apiError = failure
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 10.0)
        XCTAssertNotNil(fetchedPokemonList)
        XCTAssertEqual(pokemonListModel.pokemonList, fetchedPokemonList)
        XCTAssertEqual(fetchedPokemonList!, mockPokemonList)
        XCTAssertNil(apiError)
    }
    
    func testRequestPokemonList_Failure() {
        mockAPIClient.mockResult = .failure(.noResponse)
        
        let expectation = XCTestExpectation(description: "API Request Failure")
        var fetchedError: APIError?
        pokemonListModel.requestPokemonList { result in
            switch result {
            case .success(_):
                XCTFail("Request should fail")
            case .failure(let failure):
                fetchedError = failure
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 10.0)
        XCTAssertNotNil(fetchedError)
    }
}
