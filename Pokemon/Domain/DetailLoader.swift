//
//  DetailLoader.swift
//  Pokemon
//
//  Created by Fabio Cuomo on 26/11/2020.
//

import Foundation

public protocol DetailLoader {
    func load(completion: @escaping (PokemonDetailLoader.Result) -> Void)
}
