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
    
}
