//
//  ListLoader.swift
//  Pokemon
//
//  Created by Fabio Cuomo on 24/11/2020.
//

import Foundation

public protocol ListLoader {
    func load(completion: @escaping (PokemonListLoader.Result) -> Void)
}
