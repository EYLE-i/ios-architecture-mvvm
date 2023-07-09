//
//  PokemonDetailAPI.swift
//  ios-architecture-mvc
//
//  Created by AIR on 2023/05/09.
//

import Foundation

class PokemonDetailAPI {
    private let apiClient: APIClient
    
    init(apiClient: APIClient) {
        self.apiClient = apiClient
    }
    
    func requestPokemonDetail(pokeId: Int, imageUrl: URL, completion: @escaping (Result<PokemonDetail, APIError>) -> Void) {
        apiClient.request(PokemonDetailAPIRequest(id: pokeId)) { result in
            switch result {
            case .success(let data):
                let pokemonDetail = PokemonDetail(number: pokeId, imageUrl: imageUrl, response: data)
                completion(.success(pokemonDetail))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
}

struct PokemonDetailAPIRequest: APIRequest {
    typealias ResponseType = PokemonDetailResponse
    
    var url: String {
        return "https://pokeapi.co/api/v2/"
    }
    
    var path: String {
        return "pokemon" + "/" + String(id)
    }
    
    var id: Int
    
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
        return try decoder.decode(ResponseType.self, from: data)
    }
}
