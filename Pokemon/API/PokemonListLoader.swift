//
//  PokemonListLoader.swift
//  Pokemon
//
//  Created by Fabio Cuomo on 24/11/2020.
//

import Foundation

public class PokemonListLoader {
    let client: HTTPClient
    let url: URL

    public typealias Result = Swift.Result<[ListItem], Error>
    
    public enum Error: Swift.Error {
        case connectivity
        case invalidData
    }

    public init(url: URL, client: HTTPClient) {
        self.url = url
        self.client = client
    }
    
    public func load(completion: @escaping (PokemonListLoader.Result) -> Void) {
        client.get(from: url) { result in
            switch result {
            case let .success(data, response):
                do {
                    let items = try ListItemsMapper.map(data, response)
                    completion(.success(items))
                } catch {
                    completion(.failure(.invalidData))
                }
            case .failure:
                completion(.failure(.connectivity))
            }
        }
    }
}
