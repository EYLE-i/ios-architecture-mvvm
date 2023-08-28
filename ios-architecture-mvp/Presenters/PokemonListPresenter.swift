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
}

protocol PokemonListPresenterOutput: AnyObject {
    
}

final class PokemonListPresenter: PokemonListPresenterInput {
    private weak var view: PokemonListPresenterOutput!
    
    init(view: PokemonListPresenterOutput!) {
        self.view = view
    }
    
    private var tableDataList: [Pokemon] = [
        Pokemon(PokemonResult(name: "Bulbasaur", url: "https://pokeapi.co/api/v2/pokemon/1/")),
        Pokemon(PokemonResult(name: "Ivysaur", url: "https://pokeapi.co/api/v2/pokemon/2/")),
        Pokemon(PokemonResult(name: "Venusaur", url: "https://pokeapi.co/api/v2/pokemon/3/"))
    ]
    
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
        print(pokemon.imageUrl)
    }
}
