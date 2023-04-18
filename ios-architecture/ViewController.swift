//
//  ViewController.swift
//  ios-architecture
//
//  Created by AIR on 2023/04/02.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var pokemons = [Pokemon]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UINib(nibName: "PokemonTableViewCell", bundle: nil), forCellReuseIdentifier: "PokeCell")
        tableView.rowHeight = 60
        
        getPokemonList()
    }
    
    func getPokemonList() {
        requestPokemonAPI{ result in
            switch result {
            case .success(let data):
                self.pokemons = PokemonListModel(data).pokemons
            case .failure(let error):
                print(error)
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    func pushPokemonDetailVC(data: Pokemon) {
        let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "PokemonDetailViewController") as! PokemonDetailViewController
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    func requestPokemonAPI(completion: @escaping (Result<PokemonListResponse, APIError>) -> Void) {
        let url = "https://pokeapi.co/api/v2/pokemon/?limit=1281"
        let requestUrl = URL(string: url)!
        
        URLSession.shared.dataTask(with: requestUrl, completionHandler: {(data, response, error) in
            if let error = error {
                completion(.failure(APIError.unknown(error)))
                return
            }
            guard let data = data, let response = response as? HTTPURLResponse else {
                print("データもしくはレスポンスがnilの状態")
                return
            }
            if response.statusCode == 200 {
                let decoder = JSONDecoder()
                do {
                    let pokemonData = try decoder.decode(PokemonListResponse.self, from: data)
                    completion(.success(pokemonData))
                } catch let error {
                    completion(.failure(APIError.decode(error)))
                }
            } else {
                completion(.failure(APIError.server(response.statusCode)))
            }
        }).resume()
    }
    
    enum APIError: Error {
        case server(Int)
        case decode(Error)
        case noResponse
        case unknown(Error)
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
        pushPokemonDetailVC(data: pokemons[indexPath.row])
    }
    
}
