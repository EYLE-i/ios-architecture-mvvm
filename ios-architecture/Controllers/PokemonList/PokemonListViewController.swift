//
//  PokemonListViewController.swift
//  ios-architecture
//
//  Created by AIR on 2023/04/25.
//

import UIKit

class PokemonListViewController: UIViewController, AlertViewController {
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
        myView.favoriteFilterButton.isSelected = isCheckFavoriteFilter
        myView.tableView.reloadData()
    }
    
    override func loadView() {
        view = myView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        myView.tableView.delegate = self
        myView.tableView.dataSource = self
        myView.favoriteFilterButton.addTarget(self, action: #selector(filterByFavorite(_:)), for: .touchUpInside)
        
        model = PokemonListModel(dataStore: FavoritePokemonDataStoreImpl(), apiClient: DefaultAPIClient.shared)
        requestPokemonList()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let indexPath = myView.tableView.indexPathForSelectedRow {
            myView.tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    private func requestPokemonList() {
        model.requestPokemonList{ [weak self] result in
            switch result {
            case .success:
                break
            case .failure(let error):
                _ = self?.failure(title: error.title, message: error.description, retry: "リトライ", retryHandler: { _ in
                    self?.requestPokemonList()
                }, cancelHandler: { _ in
                    self?.myView.favoriteFilterButton.isEnabled = false
                    self?.myView.favoriteFilterButton.isHighlighted = false
                })
            }
        }
    }
    
    private func filteredTableDataList() {
        tableDataList = model.pokemonFiltered(isFilterFavorite: isCheckFavoriteFilter, favoriteNumbers: model.favoriteNumbers)
    }
    
    @objc private func filterByFavorite(_ sender: Any) {
        isCheckFavoriteFilter.toggle()
        filteredTableDataList()
    }
    
    func pushPokemonDetailVC(model: PokemonDetailModel) {
        let storyBoard = UIStoryboard(name: "PokemonDetail", bundle: nil)
        let viewController = storyBoard.instantiateViewController(withIdentifier: "PokemonDetail") as! PokemonDetailViewController
        viewController.model = model
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}

extension PokemonListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = tableDataList[indexPath.row]
        let pokemonDetailModel = PokemonDetailModel(pokeId: data.number, imageUrl: data.imageUrl!, apiClient: DefaultAPIClient.shared)
        pushPokemonDetailVC(model: pokemonDetailModel)
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
        cell.setImage(data.imageUrl)
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
        case .failure(let error):
            print(error)
            return
        }
    }
}
