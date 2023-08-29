//
//  AppDelegate.swift
//  ios-architecture-mvp
//
//  Created by AIR on 2023/04/02.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .red
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        UINavigationBar.appearance().tintColor = .white
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        
        let pokemonListViewController = UIStoryboard(name: "PokemonList", bundle: nil).instantiateInitialViewController() as! PokemonListViewController
        let navigationController = UINavigationController(rootViewController: pokemonListViewController)

        let model = PokemonListModel()
        let presenter = PokemonListPresenter(view: pokemonListViewController, model: model)
        pokemonListViewController.inject(presenter: presenter)

        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        
        return true
    }
    
}

