//
//  AppDelegate.swift
//  Pokemon
//
//  Created by Fabio Cuomo on 23/11/2020.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.rootViewController = UINavigationController(rootViewController: makeMainController())
        window.makeKeyAndVisible()
        self.window = window
        return true
    }

    private func makeMainController() -> UIViewController {
        let httpClient = URLSessionHTTPClient()
        let pokemonListURL = URL(string: PokemonListLoader.Constants.PokemonListURL)!
        let remoteLoader = PokemonListLoader(url: pokemonListURL, client: httpClient)
        let viewModel = ListViewModel(with: remoteLoader)
        
        return ListViewController(viewModel: viewModel)
    }
}

