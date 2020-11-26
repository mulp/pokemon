//
//  ListItemsMapper.swift
//  Pokemon
//
//  Created by Fabio Cuomo on 24/11/2020.
//

import Foundation

final class ListItemsMapper {
    private struct Root: Decodable {
        let results: [Item]
    }

    private struct Item: Decodable {
        let name: String
        let url: String

        var item: ListItem {
            return ListItem(name: name, targetURL: URL(string: url))
        }
    }

    static let OK_200: Int = 200

    static func map(_ data: Data, _ response: HTTPURLResponse) throws -> [ListItem] {
        guard response.statusCode == OK_200 else {
            throw PokemonListLoader.Error.invalidData
        }

        let root = try JSONDecoder().decode(Root.self, from: data)
        return root.results.map { $0.item }
    }
}
