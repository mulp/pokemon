//
//  DetailItemMapper.swift
//  Pokemon
//
//  Created by Fabio Cuomo on 26/11/2020.
//

import Foundation

final class DetailItemMapper {
    private struct Item: Decodable {
        let id: Int
        let name: String
        let sprites: Sprite
        let stats: [ItemStats]
        let types: [ItemTypes]

        var detail: DetailItem {
            let detailStats = stats.map { Stats(baseStats: $0.baseStats, name: $0.stat.name) }
            let detailsTypes = types.map { Types(slot: $0.slot, name: $0.type.name) }
            return DetailItem(id: id, name: name, image: sprites.frontDefault, stats: detailStats, types: detailsTypes)
        }
    }
    
    private struct Sprite: Decodable {
        let frontDefault: String
        
        private enum CodingKeys : String, CodingKey {
            case frontDefault = "front_default"
        }
    }
    
    private struct ItemStats: Decodable {
        let baseStats: Int
        let stat: ItemStat
        
        private enum CodingKeys: String, CodingKey {
            case baseStats = "base_stat", stat
        }
    }

    private struct ItemStat: Decodable {
        let name: String
    }
    
    private struct ItemTypes: Decodable {
        let slot: Int
        let type: ItemType
    }

    private struct ItemType: Decodable {
        let name: String
    }

    static let OK_200: Int = 200

    static func map(_ data: Data, _ response: HTTPURLResponse) throws -> DetailItem {
        guard response.statusCode == OK_200 else {
            throw PokemonDetailLoader.Error.invalidData
        }

        let pokemon = try JSONDecoder().decode(Item.self, from: data)
        return pokemon.detail
    }
}
