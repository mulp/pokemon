//
//  PokemonDetailLoader.swift
//  Pokemon
//
//  Created by Fabio Cuomo on 26/11/2020.
//

import Foundation

public class PokemonDetailLoader: DetailLoader {
    let client: HTTPClient
    let url: URL

    public typealias Result = Swift.Result<DetailItem, PokemonDetailLoader.Error>
    
    public enum Error: Swift.Error {
        case connectivity
        case invalidData
        case unknown
    }

    public init(url: URL, client: HTTPClient) {
        self.url = url
        self.client = client
    }
    
    public func load(completion: @escaping (PokemonDetailLoader.Result) -> Void) {
        client.get(from: url) { [weak self] result in
            guard self != nil else { return }
            
            switch result {
            case let .success(data, response):
                do {
                    let items = try DetailItemMapper.map(data, response)
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
