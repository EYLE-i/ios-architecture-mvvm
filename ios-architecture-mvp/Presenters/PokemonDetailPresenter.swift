//
//  PokemonDetailPresenter.swift
//  ios-architecture-mvp
//
//  Created by AIR on 2023/09/07.
//

import Foundation

protocol PokemonDetailPresenterInput {
    var pokemonDetail: PokemonDetail! { get }
    func viewDidLoad()
    func fetchPokemonDetail()
}

protocol PokemonDetailPresnterOutput: AnyObject {
    func updatePokemonDetailView()
    func visibleHUD(isVisible: Bool)
    func showFailureDialog(error: APIError)
}

final class PokemonDetailPresenter: PokemonDetailPresenterInput {
    private weak var view: PokemonDetailPresnterOutput!
    private var model: PokemonDetailModelInput
    
    init(view: PokemonDetailPresnterOutput, model: PokemonDetailModelInput) {
        self.view = view
        self.model = model
    }
    
    var pokemonDetail: PokemonDetail!
    
    func viewDidLoad() {
        self.view.visibleHUD(isVisible: true)
        fetchPokemonDetail()
    }
    
    func fetchPokemonDetail() {
        model.fetchPokemonDetail { [weak self] result in
            switch result {
            case .success(let success):
                self?.pokemonDetail = success
                DispatchQueue.main.async {
                    self?.view.updatePokemonDetailView()
                }
                self?.view.visibleHUD(isVisible: false)
            case .failure(let failure):
                self?.view.showFailureDialog(error: failure)
            }
        }
    }
    
}
