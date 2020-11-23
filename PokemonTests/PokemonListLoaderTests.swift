//
//  PokemonListLoaderTests.swift
//  PokemonTests
//
//  Created by Fabio Cuomo on 23/11/2020.
//

import XCTest
@testable import Pokemon

class HTTPClient {
    var requestedURL: URL?
}

class PokemonListLoader {
    
}

class PokemonListLoaderTests: XCTestCase {

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    func test_init_doesNotRequestLoadData() {
        let client = HTTPClient()
        _ = PokemonListLoader()
        
        XCTAssertNil(client.requestedURL)
    }
}
