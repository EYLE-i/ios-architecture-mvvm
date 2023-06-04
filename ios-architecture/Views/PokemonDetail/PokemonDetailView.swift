//
//  PokemonDetailView.swift
//  ios-architecture
//
//  Created by AIR on 2023/05/09.
//

import UIKit
import Kingfisher

class PokemonDetailView: XibLoadView {

    @IBOutlet weak var pokemonImageView: UIImageView!
    @IBOutlet weak var numberView: UIView!
    @IBOutlet weak var nameView: UIView!
    @IBOutlet weak var heightView: UIView!
    @IBOutlet weak var weightView: UIView!
    
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var heightLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    
    func setImage(_ imageUrl: URL?) {
        pokemonImageView.kf.setImage(
            with: imageUrl,
            placeholder: UIImage(named: "monsterBall")
        )
    }
}

extension UIView {
    func addBorder(width: CGFloat, color: UIColor) {
        let border = CALayer()
        border.frame = CGRect(x: 0, y: self.frame.height - width, width: self.frame.width, height: width)
        border.backgroundColor = color.cgColor
        self.layer.addSublayer(border)
    }
}
