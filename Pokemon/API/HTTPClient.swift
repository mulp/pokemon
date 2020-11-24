//
//  HTTPClient.swift
//  Pokemon
//
//  Created by Fabio Cuomo on 24/11/2020.
//

import Foundation

public enum HTTPClientResult {
    case success(Data, HTTPURLResponse)
    case failure(Error)
}

public protocol HTTPClient {
    func get(from url: URL, completion: @escaping (HTTPClientResult) -> Void)
}
