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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setData(_ data: PokemonResult) {
        let url = getPokemonURL(data.url)
        
        self.pokeLabel.text = data.name
        self.pokeImageView.kf.setImage(
            with: url,
            placeholder: UIImage(named: "monsterBall")
        )
        
    }
    
    func getPokemonURL(_ url: String) -> URL?{
        var pokeID = url.dropLast(1)
        if let range = pokeID.range(of: "https://pokeapi.co/api/v2/pokemon/") {
            pokeID.removeSubrange(range)
        }
        let pokeIDStr = String(pokeID)
        let pokeUrl = URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/\(pokeIDStr).png")
        return pokeUrl
    }
    
}
