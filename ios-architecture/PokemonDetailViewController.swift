//
//  PokemonDetailViewController.swift
//  ios-architecture
//
//  Created by AIR on 2023/04/18.
//

import UIKit

protocol SegueDelegate: AnyObject {
    func passFavoriteValue(pokemon: DummyPokemon)
}

class PokemonDetailViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    
    weak var delegate: SegueDelegate?
    
    var pokemon: DummyPokemon!
    var index: Int!

    private lazy var favoriteButton = UIBarButtonItem(
        image: UIImage(systemName: "star"), style: .plain, target: self, action: #selector(self.favoriteButtonTap(_:))
    )
    
    var isFavorite = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.delegate = self
        
        navigationItem.rightBarButtonItem = favoriteButton
        
//        isFavorite = pokemon.isFavorite
        updateFavoriteButton()
    }
    
    func updateFavoriteButton() {
        if pokemon.isFavorite {
            favoriteButton.image = UIImage(systemName: "star.fill")
        } else {
            favoriteButton.image = UIImage(systemName: "star")
        }
    }
    
    @objc
    private func favoriteButtonTap(_ button: UIBarButtonItem) {
//        self.isFavorite = !isFavorite
        pokemon.isFavorite = !pokemon.isFavorite
        updateFavoriteButton()
    }

}

extension PokemonDetailViewController: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        if viewController is ViewController {
            delegate?.passFavoriteValue(pokemon: pokemon)
        }
    }
}
