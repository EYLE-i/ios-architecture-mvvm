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
        let data = tableDataList[indexPath.row]
        cell.nameLabel.text = data.name
        cell.favoriteButton.isSelected = model.favoriteNumbers.contains(data.number)
        return cell
    }
}
