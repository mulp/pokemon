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
    let url: URL
    
    init(url: URL, client: HTTPClient) {
        self.url = url
        self.client = client
    }
    
    func load() {
        client.get(from: url)
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
        let url = URL(string: "http://a-valid.url.com")!
        let client = HTTPClientSpy()
        _ = PokemonListLoader(url: url, client: client)
        
        XCTAssertNil(client.requestedURL)
    }

    func test_load_requestDataFromURL() {
        let url = URL(string: "http://a-valid.url.com")!
        let client = HTTPClientSpy()
        let sut = PokemonListLoader(url: url, client: client)

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
