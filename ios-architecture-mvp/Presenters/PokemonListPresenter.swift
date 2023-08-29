//
//  PokemonListPresenter.swift
//  ios-architecture-mvp
//
//  Created by AIR on 2023/08/28.
//

import Foundation

protocol PokemonListPresenterInput {
    var numberOfTableDataList: Int { get }
    func pokemon(forRow row: Int) -> Pokemon?
    func didSelectRow(at indexPath: IndexPath)
    func viewDidLoad()
}

protocol PokemonListPresenterOutput: AnyObject {
    func updatePokemonList()
}

final class PokemonListPresenter: PokemonListPresenterInput {
    private weak var view: PokemonListPresenterOutput!
    private var model: PokemonListModelInput
    
    init(view: PokemonListPresenterOutput, model: PokemonListModelInput) {
        self.view = view
        self.model = model
    }
    
    private(set) var tableDataList: [Pokemon] = []
    
    var numberOfTableDataList: Int {
        return tableDataList.count
    }
    
    func pokemon(forRow row: Int) -> Pokemon? {
        guard row < tableDataList.count else { return nil }
        return tableDataList[row]
    }
    
    func didSelectRow(at indexPath: IndexPath) {
        guard let pokemon = pokemon(forRow: indexPath.row) else { return }
        print(pokemon.name)
        print(pokemon.imageUrl!)
    }
    
    func viewDidLoad() {
        model.fetchPokemonList { [weak self] result in
            switch result {
            case .success(let pokemonList):
                self?.tableDataList = pokemonList
                DispatchQueue.main.async {
                    self?.view.updatePokemonList()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}
