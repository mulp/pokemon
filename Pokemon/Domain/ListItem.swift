//
//  ListItem.swift
//  Pokemon
//
//  Created by Fabio Cuomo on 23/11/2020.
//

import Foundation

public struct ListItem: Equatable {
    public let name: String
    public let targetURL: URL
    
    public init(name: String, targetURL: URL) {
        self.name = name
        self.targetURL = targetURL
    }
}
