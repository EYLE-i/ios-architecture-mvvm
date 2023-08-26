//
//  PokemonListAPIRequestTests.swift
//  ios-architecture-mvpTests
//
//  Created by AIR on 2023/07/13.
//

import XCTest
@testable import ios_architecture_mvp

final class PokemonListAPIRequestTests: XCTestCase {
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testRequestURL() {
        let request = PokemonListAPIRequest()
        
        XCTAssertEqual(request.url, "https://pokeapi.co/api/v2/")
        XCTAssertEqual(request.path, "pokemon")
        XCTAssertEqual(request.httpMethod, "GET")
        XCTAssertEqual(request.headers, [:])
        XCTAssertNil(request.body)
        XCTAssertEqual(request.queries, ["limit": "1281"])
        XCTAssertEqual(request.timeout, 60)
    }
    
    func testDecodeResponse() throws {
        let request = PokemonListAPIRequest()
        
        let responseString = """
            {
                "count": 100,
                "next": "https://pokeapi.co/api/v2/pokemon?offset=20&limit=20",
                "previous": null,
                "results": [
                    {
                        "name": "bulbasaur",
                        "url": "https://pokeapi.co/api/v2/pokemon/1/"
                    },
                    {
                        "name": "charmander",
                        "url": "https://pokeapi.co/api/v2/pokemon/4/"
                    },
                    {
                        "name": "squirtle",
                        "url": "https://pokeapi.co/api/v2/pokemon/7/"
                    }
                ]
            }
            """
        
        let responseData = responseString.data(using: .utf8)!
        
        let decodedResponse = try request.decode(from: responseData)
        XCTAssertEqual(decodedResponse.count, 100)
        XCTAssertEqual(decodedResponse.next, "https://pokeapi.co/api/v2/pokemon?offset=20&limit=20")
        XCTAssertNil(decodedResponse.previous)
        XCTAssertEqual(decodedResponse.results.count, 3)
        
        XCTAssertEqual(decodedResponse.results[0].name, "bulbasaur")
        XCTAssertEqual(decodedResponse.results[0].url, "https://pokeapi.co/api/v2/pokemon/1/")
        
        XCTAssertEqual(decodedResponse.results[1].name, "charmander")
        XCTAssertEqual(decodedResponse.results[1].url, "https://pokeapi.co/api/v2/pokemon/4/")
        
        XCTAssertEqual(decodedResponse.results[2].name, "squirtle")
        XCTAssertEqual(decodedResponse.results[2].url, "https://pokeapi.co/api/v2/pokemon/7/")
    }
    
}
