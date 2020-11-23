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
        let (_, client) = makeSUT()

        XCTAssertTrue(client.requestedURLs.isEmpty)
    }

    func test_load_requestDataFromURL() {
        let (sut, client) = makeSUT()

        sut.load()
        
        XCTAssertFalse(client.requestedURLs.isEmpty)
    }
    
    func test_loadTwice_requestDataFromURLTwice() {
        let url = URL(string: "http://a-valid.url.com")!
        let (sut, client) = makeSUT(url: url)

        sut.load()
        sut.load()

        XCTAssertEqual(client.requestedURLs, [url, url])
    }

    // MARK: Helpers
    func makeSUT(url: URL = URL(string: "http://a-valid.url.com")!) -> (sut: PokemonListLoader, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = PokemonListLoader(url: url, client: client)
        return (sut, client)
    }
    
    class HTTPClientSpy: HTTPClient {
        var requestedURL: URL?
        var requestedURLs = [URL]()
        
        func get(from url: URL) {
            requestedURLs.append(url)
        }
    }
}
