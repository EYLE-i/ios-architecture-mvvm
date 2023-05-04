//
//  PokemonListViewController.swift
//  ios-architecture
//
//  Created by AIR on 2023/04/25.
//

import UIKit

class PokemonListViewController: UIViewController {
    var model: PokemonListModel! {
        didSet {
            registerModel()
        }
    }
    
    private lazy var myView = PokemonListView()
    
    private var tableDataList: [Pokemon] = [] {
        didSet {
            updateView()
        }
    }
    
    private var isCheckFavoriteFilter = false
    
    deinit {
        model.notificationCenter.removeObserver(self)
    }
    
    private func registerModel() {
        _ = model.notificationCenter
            .addObserver(forName: .init(rawValue: "pokemonList"),
                         object: nil,
                         queue: nil) { [weak self] notification in
                if let pokemonList = notification.userInfo?["pokemonList"] as? [Pokemon] {
                    self?.tableDataList = pokemonList
                }
            }
    }
    
    private func updateView() {
        myView.tableView.reloadData()
    }
    
    override func loadView() {
        view = myView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        myView.tableView.delegate = self
        myView.tableView.dataSource = self
        
        model = PokemonListModel(dataStore: FavoritePokemonDataStoreImpl(), apiClient: DefaultAPIClient.shared)
        requestPokemonList()
    }
    
    private func requestPokemonList() {
        model.requestPokemonList{ result in
            switch result {
            case .success:
                break
            case .failure:
                print("failure")
            }
        }
    }
    
    private func filteredTableDataList() {
        tableDataList = model.pokemonFiltered(isFilterFavorite: isCheckFavoriteFilter, favoriteNumbers: model.favoriteNumbers)
    }
}

extension PokemonListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("selected")
    }
}

extension PokemonListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableDataList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: myView.cellIdentifier, for: indexPath) as! PokemonListTableViewCell
        cell.delegate = self
        let data = tableDataList[indexPath.row]
        cell.nameLabel.text = data.name
        cell.favoriteButton.isSelected = model.favoriteNumbers.contains(data.number)
        return cell
    }
}

extension PokemonListViewController: PokemonListTableViewCellDelegate {
    func pokemonListTableViewCell(_ cell: PokemonListTableViewCell, didChangeFavorite sender: Any) {
        guard let indexPath = myView.tableView.indexPath(for: cell) else {
            return
        }
        let data = tableDataList[indexPath.row]
        let result = model.updateFavoriteNumbers(number: data.number)
        switch result {
        case .success:
            filteredTableDataList()
        case .failure:
            print("failure")
            return
        }
    }
}
