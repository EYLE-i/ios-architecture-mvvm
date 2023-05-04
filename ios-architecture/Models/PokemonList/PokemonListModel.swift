//
//  PokemonListModel.swift
//  ios-architecture
//
//  Created by AIR on 2023/04/26.
//

import Foundation

final class PokemonListModel {
    let notificationCenter = NotificationCenter.default
    
    private(set) var pokemonList: [Pokemon]! {
        didSet {
            notificationCenter.post(
                name: .init(rawValue: "pokemonList"),
                object: nil,
                userInfo: ["pokemonList": pokemonList!]
            )
        }
    }
    let dataStore: FavoritePokemonDataStore
    private(set) var favoriteNumbers: [Int]
    private let pokemonListAPI: PokemonListAPI
    
    public init(dataStore: FavoritePokemonDataStore, apiClient: APIClient) {
        self.dataStore = dataStore
        self.favoriteNumbers = dataStore.fetchAll()
        self.pokemonListAPI = .init(apiClient: apiClient)
    }
    
    func requestPokemonList(_ completion: @escaping (Result<[Pokemon], APIError>) -> Void) {
        pokemonListAPI.requestPokemonList { [weak self] result in
            DispatchQueue.main.async {
                if case .success(let pokemonList) = result {
                    self?.pokemonList = pokemonList
                }
                completion(result)
            }
        }
    }
    
    func pokemonFiltered(isFilterFavorite: Bool,
                         favoriteNumbers: [Int]) -> [Pokemon] {
        return pokemonList.filter{
            if isFilterFavorite {
                return favoriteNumbers.contains($0.number)
            } else {
                return true
            }
        }
    }
    
    func updateFavoriteNumbers(number: Int) -> Result<[Int], FavoritePokemonDataStoreError> {
        let result: Result<[Int], FavoritePokemonDataStoreError>
        if favoriteNumbers.contains(number) {
            result = dataStore.remove([number])
        } else {
            result = dataStore.add([number])
        }
        if case let .success(numbers) = result {
            favoriteNumbers = numbers
        }
        return result
    }
}
