//
//  PokemonDetailViewController.swift
//  ios-architecture-mvp
//
//  Created by AIR on 2023/05/09.
//

import UIKit
import PKHUD

class PokemonDetailViewController: UIViewController, AlertViewController {
    
    private lazy var myView = PokemonDetailView()
    
    private var presenter: PokemonDetailPresenterInput!
    
    func inject(presenter: PokemonDetailPresenterInput) {
        self.presenter = presenter
    }
    
    override func loadView() {
        view = myView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewDidLoad()
    }
}

extension PokemonDetailViewController: PokemonDetailPresnterOutput {
    func updatePokemonDetailView() {
        myView.setImage(presenter.pokemonDetail.imageUrl!)
        myView.numberLabel.text = String(presenter.pokemonDetail.number)
        myView.nameLabel.text = presenter.pokemonDetail.name
        myView.heightLabel.text = String(presenter.pokemonDetail.height)
        myView.weightLabel.text = String(presenter.pokemonDetail.weight)
        myView.setBorder()
    }
    
    func visibleHUD(isVisible: Bool) {
        DispatchQueue.main.async {
            if isVisible {
                HUD.show(.progress)
            } else {
                HUD.hide()
            }
        }
    }
    
    func showFailureDialog(error: APIError) {
        _ = self.failure(title: error.title, message: error.description, retry: "リトライ", retryHandler: { [weak self] _ in
            self?.presenter.fetchPokemonDetail()
        })
    }
}
