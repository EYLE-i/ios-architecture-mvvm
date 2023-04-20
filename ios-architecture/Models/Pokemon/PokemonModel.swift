//
//  PokemonModel.swift
//  ios-architecture
//
//  Created by AIR on 2023/04/21.
//

import Foundation

final class PokemonModel {
    let notificationCenter = NotificationCenter.default
    private(set) var pokemon: [Pokemon]! {
        didSet {
            notificationCenter.post(
                name: .init("pokemon"),
                object: nil,
                userInfo: ["pokemon": pokemon!]
            )
        }
    }
    private let pokeListAPI: PokeListAPI
    
    public init(apiClient: APIClient) {
        self.pokeListAPI = .init(apiClient: apiClient)
    }
    
    func requestPokeList(_ completion: @escaping (Result<PokemonListResponse, APIError>) -> Void) {
        pokeListAPI.requestPokeList { [weak self] result in
            if case .success(let pokemonListResponse) = result {
                self?.pokemon = PokemonListModel(pokemonListResponse).pokemons
            }
            completion(result)
        }
    }
}
