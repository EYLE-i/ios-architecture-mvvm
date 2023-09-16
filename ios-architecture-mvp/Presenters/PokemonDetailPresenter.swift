//
//  PokemonDetailPresenter.swift
//  ios-architecture-mvp
//
//  Created by AIR on 2023/09/07.
//

import Foundation

protocol PokemonDetailPresenterInput {
    func viewDidLoad()
}

protocol PokemonDetailPresnterOutput: AnyObject {
    
}

final class PokemonDetailPresenter: PokemonDetailPresenterInput {
    
    private weak var view: PokemonDetailPresnterOutput!
    private var model: PokemonDetailModelInput
    
    init(view: PokemonDetailPresnterOutput, model: PokemonDetailModelInput) {
        self.view = view
        self.model = model
    }
    
    func viewDidLoad() {
        print(#function)
    }
    
}
