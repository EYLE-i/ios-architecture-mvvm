//
//  PokemonDetailViewController.swift
//  ios-architecture-mvc
//
//  Created by AIR on 2023/05/09.
//

import UIKit
import PKHUD

class PokemonDetailViewController: UIViewController, AlertViewController {
    var model: PokemonDetailModel! {
        didSet {
            registerModel()
        }
    }
    
    deinit {
        model.notificationCenter.removeObserver(self)
    }
    
    private func registerModel() {
        _ = model.notificationCenter.addObserver(forName: .init("pokemonDetail"), object: nil, queue: nil) { [weak self] notification in
            if let pokemonDetail = notification.userInfo?["pokemonDetail"] as? PokemonDetail {
                DispatchQueue.main.sync {
                    self?.updateView(pokemonDetail: pokemonDetail)
                }
            }
        }
    }
    
    private lazy var myView = PokemonDetailView()
    
    override func loadView() {
        view = myView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        visibleHUD(isVisible: true)
        requestPokemonDetail()
        setUpView()
    }
    
    private func setUpView() {
        myView.setImage(model.imageUrl)
        myView.setBorder()
    }
    
    private func updateView(pokemonDetail: PokemonDetail) {
        myView.numberLabel.text = String(pokemonDetail.number)
        myView.nameLabel.text = pokemonDetail.name
        myView.heightLabel.text = String(pokemonDetail.height)
        myView.weightLabel.text = String(pokemonDetail.weight)
    }
    
    private func requestPokemonDetail() {
        model.requestPokemonDetail { [weak self] result in
            switch result {
            case .success:
                self?.visibleHUD(isVisible: false)
                break
            case .failure(let error):
                _ = self?.failure(title: error.title, message: error.description, retry: "リトライ") { _ in
                    self?.requestPokemonDetail()
                }
            }
        }
    }
    
    private func visibleHUD(isVisible: Bool) {
        DispatchQueue.main.async {
            if isVisible {
                HUD.show(.progress)
            } else {
                HUD.hide()
            }
        }
    }
}
