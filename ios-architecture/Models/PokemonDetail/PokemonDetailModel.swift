//
//  PokemonDetailModel.swift
//  ios-architecture
//
//  Created by AIR on 2023/05/22.
//

import Foundation

final class PokemonDetailModel {
    let notificationCenter = NotificationCenter.default
    private(set) var pokemonDetail: PokemonDetail! {
        didSet {
            notificationCenter.post(name: .init("pokemonDetail"),
                                    object: nil,
                                    userInfo: ["pokemonDetail": pokemonDetail!]
            )
        }
    }
    
    private let pokemonDetailAPI: PokemonDetailAPI
    private let pokeId: Int
    let imageUrl: URL
    
    init(pokeId: Int, imageUrl: URL, apiClient: APIClient) {
        self.pokeId = pokeId
        self.imageUrl = imageUrl
        self.pokemonDetailAPI = .init(apiClient: apiClient)
    }
    
    func requestPokemonDetail(_ completion: @escaping (Result<PokemonDetail, APIError>) -> Void) {
        pokemonDetailAPI.requestPokemonDetail(pokeId: pokeId, imageUrl: imageUrl) { [weak self] result in
            if case .success(let pokemonDetail) = result {
                self?.pokemonDetail = pokemonDetail
            }
            completion(result)
        }
    }
}
