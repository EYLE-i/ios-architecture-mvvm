//
//  PokemonTableViewCell.swift
//  ios-architecture
//
//  Created by AIR on 2023/04/17.
//

import UIKit
import Kingfisher

class PokemonTableViewCell: UITableViewCell {
    
    @IBOutlet weak var pokeLabel: UILabel!
    @IBOutlet weak var pokeImageView: UIImageView!
    @IBOutlet weak var favoriteImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func set(_ data: DummyPokemon) {
        self.pokeLabel.text = data.name
        self.pokeImageView.kf.setImage(
            with: data.imageUrl,
            placeholder: UIImage(named: "monsterBall")
        )
        self.favoriteImageView.image = setFavImageView(data.isFavorite)
        self.favoriteImageView.tintColor = .yellow
    }
    
    func setFavImageView(_ isFavorite: Bool) -> UIImage? {
        if isFavorite {
            return UIImage(systemName: "star.fill")
        } else {
            return UIImage(systemName: "star")
        }
    }
}
