//
//  PokemonListLoaderTests.swift
//  PokemonTests
//
//  Created by Fabio Cuomo on 23/11/2020.
//

import XCTest
@testable import Pokemon

protocol HTTPClient {
    func get(from url: URL)
}

class PokemonListLoader {
    let client: HTTPClient
    
    init(client: HTTPClient) {
        self.client = client
    }
}

class PokemonListLoaderTests: XCTestCase {

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    func test_init_doesNotRequestLoadData() {
        let client = HTTPClientSpy()
        _ = PokemonListLoader(client: client)
        
        XCTAssertNil(client.requestedURL)
    }
    
    // MARK: Helpers
    class HTTPClientSpy: HTTPClient {
        var requestedURL: URL?
        
        func get(from url: URL) {
            requestedURL = url
        }
    }
}
