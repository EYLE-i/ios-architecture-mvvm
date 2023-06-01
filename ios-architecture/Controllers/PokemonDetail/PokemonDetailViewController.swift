//
//  PokemonDetailViewController.swift
//  ios-architecture
//
//  Created by AIR on 2023/05/09.
//

import UIKit

class PokemonDetailViewController: UIViewController {

    private lazy var myView = PokemonDetailView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func loadView() {
        view = myView
    }
}
