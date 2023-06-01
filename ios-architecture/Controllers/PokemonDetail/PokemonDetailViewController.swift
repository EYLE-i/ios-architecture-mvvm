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

        updateView()
    }
    
    override func loadView() {
        view = myView
    }
    
    private func updateView() {
        let borderWidth = 0.5
        let borderColor = UIColor.black
        myView.numberView.addBorder(width: borderWidth, color: borderColor)
        myView.nameView.addBorder(width: borderWidth, color: borderColor)
        myView.heightView.addBorder(width: borderWidth, color: borderColor)
        myView.weightView.addBorder(width: borderWidth, color: borderColor)
    }
}
