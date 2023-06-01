//
//  PokemonDetailView.swift
//  ios-architecture
//
//  Created by AIR on 2023/05/09.
//

import UIKit

class PokemonDetailView: XibLoadView {

    @IBOutlet weak var pokemonImageView: UIImageView!
    @IBOutlet weak var numberView: UIView!
    @IBOutlet weak var nameView: UIView!
    @IBOutlet weak var heightView: UIView!
    @IBOutlet weak var weightView: UIView!
}

extension UIView {
    func addBorder(width: CGFloat, color: UIColor) {
        let border = CALayer()
        border.frame = CGRect(x: 0, y: self.frame.height - width, width: self.frame.width, height: width)
        border.backgroundColor = color.cgColor
        self.layer.addSublayer(border)
    }
}
