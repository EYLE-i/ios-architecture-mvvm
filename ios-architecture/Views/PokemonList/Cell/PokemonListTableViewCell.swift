//
//  PokemonListTableViewCell.swift
//  ios-architecture
//
//  Created by AIR on 2023/04/25.
//

import UIKit

protocol PokemonListTableViewCellDelegate: AnyObject {
    func pokemonListTableViewCell(_ cell: PokemonListTableViewCell, didChangeFavorite sender: Any)
}

class PokemonListTableViewCell: UITableViewCell {
    weak var delegate: PokemonListTableViewCellDelegate?
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBAction func changeFavorite(_ sender: Any) {
        delegate?.pokemonListTableViewCell(self, didChangeFavorite: sender)
    }
}
