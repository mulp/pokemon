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
    
    func load() {
        client.get(from: URL(string: "http://a-valid.url.com")!)
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

    func test_load_requestDataFromURL() {
        let client = HTTPClientSpy()
        let sut = PokemonListLoader(client: client)

        sut.load()
        
        XCTAssertNotNil(client.requestedURL)
    }
    

    // MARK: Helpers
    class HTTPClientSpy: HTTPClient {
        var requestedURL: URL?
        
        func get(from url: URL) {
            requestedURL = url
        }
    }
}
