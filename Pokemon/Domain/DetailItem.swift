//
//  DetailItem.swift
//  Pokemon
//
//  Created by Fabio Cuomo on 26/11/2020.
//

import Foundation

public struct DetailItem: Equatable {
    public let id: Int
    public let name: String
    public let image: String
    public let stats: [Stats]
    public let types: [Types]
    
    public init(id: Int, name: String, image: String, stats: [Stats], types: [Types]) {
        self.id = id
        self.name = name
        self.image = image
        self.stats = stats
        self.types = types
    }
}

public struct Stats: Equatable {
    public let baseStats: Int
    public let name: String

    public init(baseStats: Int, name: String) {
        self.baseStats = baseStats
        self.name = name
    }
}

public struct Types: Equatable {
    public let slot: Int
    public let name: String
    
    public init(slot: Int, name: String) {
        self.slot = slot
        self.name = name
    }
}
