//
//  ViewController.swift
//  ios-architecture
//
//  Created by AIR on 2023/04/02.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    let array = ["aaa", "iii", "uuu", "eee", "ooo"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UINib(nibName: "PokemonTableViewCell", bundle: nil), forCellReuseIdentifier: "PokeCell")
        tableView.rowHeight = 60
        requestPokemonAPI()
    }
    
    func requestPokemonAPI() {
        let url = "https://pokeapi.co/api/v2/pokemon/?limit=1281"
        let requestUrl = URL(string: url)!
        
        URLSession.shared.dataTask(with: requestUrl, completionHandler: {(data, response, error) in
            if let error = error {
                print(error)
                return
            }
            guard let data = data, let response = response as? HTTPURLResponse else {
                print("データもしくはレスポンスがnilの状態")
                return
            }
            if response.statusCode == 200 {
                let decoder = JSONDecoder()
                do {
                    let pokemonData = try decoder.decode(PokemonList.self, from: data)
                    print(pokemonData.results[0].name)
                } catch let error {
                    print(error)
                }
            } else {
                print("StatusCode: \(response.statusCode)")
            }
        }).resume()
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return array.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PokeCell", for: indexPath) as! PokemonTableViewCell
        cell.pokeLabel.text = array[indexPath.row]
        return cell
    }
    
    
}
