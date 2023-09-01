//
//  PokemonListViewController.swift
//  ios-architecture-mvp
//
//  Created by AIR on 2023/04/25.
//

import UIKit

class PokemonListViewController: UIViewController, AlertViewController {
    private lazy var myView = PokemonListView()
    
    private var presenter: PokemonListPresenterInput!
    
    func inject(presenter: PokemonListPresenterInput) {
        self.presenter = presenter
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "PokemonList"
        
        myView.tableView.delegate = self
        myView.tableView.dataSource = self
        myView.favoriteFilterButton.addTarget(self, action: #selector(filterByFavorite(_:)), for: .touchUpInside)
        
        presenter.viewDidLoad()
    }
    
    override func loadView() {
        view = myView
    }
    
    @objc private func filterByFavorite(_ sender: Any) {
        presenter.filteredTableDataList()
    }
    
}

extension PokemonListViewController: PokemonListPresenterOutput {
    func updatePokemonListView() {
        myView.favoriteFilterButton.isSelected = presenter.isCheckFavoriteFilter
        myView.tableView.reloadData()
    }
}

extension PokemonListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        presenter.didSelectRow(at: indexPath)
    }
}

extension PokemonListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.numberOfTableDataList
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: myView.cellIdentifier, for: indexPath) as! PokemonListTableViewCell
        cell.delegate = self
        if let pokemon = presenter.pokemon(forRow: indexPath.row) {
            cell.nameLabel.text = pokemon.name
            cell.setImage(pokemon.imageUrl)
            cell.favoriteButton.isSelected = presenter.checkFavorite(forRow: indexPath.row)
        }
        return cell
    }
}

extension PokemonListViewController: PokemonListTableViewCellDelegate {
    func pokemonListTableViewCell(_ cell: PokemonListTableViewCell, didChangeFavorite sender: Any) {
        guard let indexPath = myView.tableView.indexPath(for: cell) else {
            return
        }
        presenter.didTapFavoriteButton(at: indexPath)
    }
}
