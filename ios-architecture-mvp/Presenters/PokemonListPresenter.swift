//
//  PokemonListPresenter.swift
//  ios-architecture-mvp
//
//  Created by AIR on 2023/08/28.
//

import Foundation

protocol PokemonListPresenterInput {
    var numberOfTableDataList: Int { get }
    var isCheckFavoriteFilter: Bool { get }
    func pokemon(forRow row: Int) -> Pokemon?
    func didSelectRow(at indexPath: IndexPath)
    func viewDidLoad()
    func filteredTableDataList()
    func didTapFavoriteButton(at number: Int)
    func checkFavorite(forRow row: Int) -> Bool
}

protocol PokemonListPresenterOutput: AnyObject {
    func updatePokemonListView()
}

final class PokemonListPresenter: PokemonListPresenterInput {
    private weak var view: PokemonListPresenterOutput!
    private var model: PokemonListModelInput
    
    init(view: PokemonListPresenterOutput, model: PokemonListModelInput) {
        self.view = view
        self.model = model
    }
    
    private(set) var tableDataList: [Pokemon] = []
    private(set) var pokemonList: [Pokemon] = []
    
    var numberOfTableDataList: Int {
        return tableDataList.count
    }
    
    var isCheckFavoriteFilter: Bool = false
    
    func pokemon(forRow row: Int) -> Pokemon? {
        guard row < tableDataList.count else { return nil }
        return tableDataList[row]
    }
    
    func didSelectRow(at indexPath: IndexPath) {
        guard let pokemon = pokemon(forRow: indexPath.row) else { return }
    }
    
    func viewDidLoad() {
        model.fetchPokemonList { [weak self] result in
            switch result {
            case .success(let pokemonList):
                self?.tableDataList = pokemonList
                self?.pokemonList = pokemonList
                DispatchQueue.main.async {
                    self?.view.updatePokemonListView()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func filteredTableDataList() {
        isCheckFavoriteFilter.toggle()
        tableDataList = model.pokemonFiltered(isFilterFavorite: isCheckFavoriteFilter, favoriteNumbers: model.favoriteIds, pokemonList: pokemonList)
        self.view.updatePokemonListView()
    }
    
    func didTapFavoriteButton(at number: Int) {
        model.updateFavoriteIds(number: number)
        self.view.updatePokemonListView()
    }
    
    func checkFavorite(forRow row: Int) -> Bool {
        return model.favoriteIds.contains(row)
    }
}
