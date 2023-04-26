//
//  ViewController.swift
//  ios-architecture
//
//  Created by AIR on 2023/04/02.
//

import UIKit

class ViewController: UIViewController {
    var model: PokemonModel! {
        didSet {
            registerModel()
        }
    }
    
    deinit {
        model.notificationCenter.removeObserver(self)
    }
    
    private func registerModel() {
        _ = model.notificationCenter
            .addObserver(
                forName: .init("pokemon"),
                object: nil,
                queue: nil
            ) { [weak self] notification in
                if let pokemon = notification.userInfo?["pokemon"] as? DummyPokemonList {
                    self?.updateViews(pokemon: pokemon)
                }
            }
    }
    
    private func updateViews(pokemon: DummyPokemonList) {
        
    }
    
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var favoriteSwitch: UISwitch!
    
    var pokemons = [DummyPokemon]()
    var pokemonsList = [DummyPokemon]()
    
    var isFavoriteSwitchOn = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpTableView()
        
        getPokemonList()
    }
    
    @IBAction func switchChanged(_ sender: UISwitch) {
        setFavoriteList(sender.isOn)
        isFavoriteSwitchOn = sender.isOn
    }
    
    func setFavoriteList(_ isOn: Bool) {
        if isOn {
            self.pokemons = self.pokemonsList.filter {
                $0.isFavorite == true
            }
        } else {
            self.pokemons = self.pokemonsList
        }
        self.tableView.reloadData()
    }
    
    
    func setUpTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UINib(nibName: "PokemonTableViewCell", bundle: nil), forCellReuseIdentifier: "PokeCell")
        tableView.rowHeight = 60
    }
    
    func getPokemonList() {
        requestPokemonAPI{ result in
            switch result {
            case .success(let data):
                self.pokemons = DummyPokemonList(data).pokemons
                self.pokemonsList = DummyPokemonList(data).pokemons
            case .failure(let error):
                print(error)
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    func pushPokemonDetailVC(data: DummyPokemon, index: Int) {
        let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "PokemonDetailViewController") as! PokemonDetailViewController
        nextVC.pokemon = data
        nextVC.index = index
        nextVC.delegate = self
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    func requestPokemonAPI(completion: @escaping (Result<DummyPokemonListResponse, APIError>) -> Void) {
        let url = "https://pokeapi.co/api/v2/pokemon/?limit=1281"
        let requestUrl = URL(string: url)!
        
        URLSession.shared.dataTask(with: requestUrl, completionHandler: {(data, response, error) in
            if let error = error {
                completion(.failure(APIError.unknown(error)))
                return
            }
            guard let data = data, let response = response as? HTTPURLResponse else {
                completion(.failure(APIError.noResponse))
                return
            }
            if response.statusCode == 200 {
                let decoder = JSONDecoder()
                do {
                    let pokemonData = try decoder.decode(DummyPokemonListResponse.self, from: data)
                    completion(.success(pokemonData))
                } catch let error {
                    completion(.failure(APIError.decode(error)))
                }
            } else {
                completion(.failure(APIError.server(response.statusCode)))
            }
        }).resume()
    }
    
}

extension ViewController: SegueDelegate {
    func passFavoriteValue(pokemon: DummyPokemon) {
        let matchIndex = self.pokemonsList.firstIndex(where: {
            $0.number == pokemon.number
        })
        self.pokemonsList[matchIndex!].isFavorite = pokemon.isFavorite
        self.pokemons = self.pokemonsList
        setFavoriteList(isFavoriteSwitchOn)
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pokemons.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PokeCell", for: indexPath) as! PokemonTableViewCell
        cell.set(pokemons[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        pushPokemonDetailVC(data: pokemons[indexPath.row], index: indexPath.row)
    }
    
}
