//
//  PokemonDetailViewController.swift
//  ios-architecture
//
//  Created by AIR on 2023/04/18.
//

import UIKit

class PokemonDetailViewController: UIViewController {

    private lazy var favoriteButton = UIBarButtonItem(
        image: UIImage(systemName: "star"), style: .plain, target: self, action: #selector(self.favoriteButtonTap(_:))
    )
    
    var isFavorite = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.rightBarButtonItem = favoriteButton
    }
    
    func updateFavoriteButton() {
        if isFavorite {
            favoriteButton.image = UIImage(systemName: "star.fill")
        } else {
            favoriteButton.image = UIImage(systemName: "star")
        }
    }
    
    @objc
    private func favoriteButtonTap(_ button: UIBarButtonItem) {
        self.isFavorite = !isFavorite
        print(isFavorite)
        updateFavoriteButton()
    }

}
