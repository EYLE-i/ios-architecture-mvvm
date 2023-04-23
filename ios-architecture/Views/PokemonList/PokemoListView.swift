//
//  PokemoListView.swift
//  ios-architecture
//
//  Created by AIR on 2023/04/23.
//

import UIKit

class PokemoListView: UIView {
    public let cellIdentifier = "cell"
    @IBOutlet weak var favoriteFilterButton: UIButton!
    @IBOutlet weak var typeFilterButton: UIButton!
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.register(UINib(nibName: cellIdentifier, bundle: Bundle(for: type(of: self))), forCellReuseIdentifier: cellIdentifier)
        }
    }
}
