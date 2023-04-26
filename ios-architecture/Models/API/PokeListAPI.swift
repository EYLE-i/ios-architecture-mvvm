//
//  PokeListAPI.swift
//  ios-architecture
//
//  Created by AIR on 2023/04/20.
//

import Foundation


class PokeListAPI {
    private let apiClient: APIClient
    
    init(apiClient: APIClient) {
        self.apiClient = apiClient
    }
    
    private let request = PokeListAPIRequest()
    
    func requestPokeList(completion: @escaping (Result<DummyPokemonListResponse, APIError>) -> Void) {
        apiClient.request(request) { result in
            switch result {
            case .success(let data):
                completion(.success(data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

struct PokeListAPIRequest: Requestable {
    typealias Model = DummyPokemonListResponse
    
    var url: String {
        return "https://pokeapi.co/api/v2/pokemon/"
    }
    
    var httpMethod: String {
        return "GET"
    }
    
    var headers: [String: String] {
        return [:]
    }
    
    var body: Data? {
        return nil
    }
    
    var queries: [String: String] {
        return ["limit": "1281"]
    }
    
    var timeout: TimeInterval {
        return 60
    }
    
    func decode(from data: Data) throws -> DummyPokemonListResponse {
        let decoder = JSONDecoder()
        return try decoder.decode(DummyPokemonListResponse.self, from: data)
    }
    
}
