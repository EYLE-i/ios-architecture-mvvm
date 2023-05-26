//
//  PokemonDetailAPI.swift
//  ios-architecture
//
//  Created by AIR on 2023/05/09.
//

import Foundation

class PokemonDetailAPI {
    private let apiClient: APIClient
    
    init(apiClient: APIClient) {
        self.apiClient = apiClient
    }
    
    func requestPokemonDetail(pokeId: String, completion: @escaping (Result<PokemonDetailResponse, APIError>) -> Void) {
        apiClient.request(PokemonDetailAPIRequest(id: pokeId)) { result in
            switch result {
            case .success(let data):
                completion(.success(data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
}

struct PokemonDetailAPIRequest: Requestable {
    typealias Model = PokemonDetailResponse
    
    var url: String {
        return "https://pokeapi.co/api/v2/"
    }
    
    var path: String {
        return "pokemon" + "/" + id
    }
    
    var id: String
    
    var httpMethod: String {
        return "GET"
    }
    
    var headers: [String : String] {
        return [:]
    }
    
    var body: Data? {
        return nil
    }
    
    var queries: [String : String] {
        return [:]
    }
    
    var timeout: TimeInterval {
        return 60
    }
    
    func decode(from data: Data) throws -> PokemonDetailResponse {
        let decoder = JSONDecoder()
        return try decoder.decode(Model.self, from: data)
    }
}
