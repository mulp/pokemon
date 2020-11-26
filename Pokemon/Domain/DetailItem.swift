//
//  DetailItem.swift
//  Pokemon
//
//  Created by Fabio Cuomo on 26/11/2020.
//

import Foundation

public struct DetailItem {
    let id: Int
    let name: String
    let image: String
    let stats: [Stats]
    let types: [Types]
}

public struct Stats {
    public let baseStats: Int
    public let name: String
}

public struct Types {
    public let slot: Int
    public let name: String
}
