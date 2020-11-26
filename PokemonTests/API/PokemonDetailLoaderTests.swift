//
//  PokemonDetailLoaderTests.swift
//  PokemonTests
//
//  Created by Fabio Cuomo on 26/11/2020.
//

import XCTest
import Pokemon

class PokemonDetailLoaderTests: XCTestCase {

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
        let url = URL(string: "http://a-valid.url.com")!
        let (sut, client) = makeSUT(url: url)

        sut.load { _ in }
        
        XCTAssertEqual(client.requestedURLs, [url])
    }
    
    func test_loadTwice_requestDataFromURLTwice() {
        let url = URL(string: "http://a-valid.url.com")!
        let (sut, client) = makeSUT(url: url)

        sut.load { _ in }
        sut.load { _ in }

        XCTAssertEqual(client.requestedURLs, [url, url])
    }
    
    func test_load_deliversErrorOnClientError() {
        let (sut, client) = makeSUT()

        expect(sut, toCompleteWithResult: .failure(.connectivity)) {
            let clientError = NSError(domain: "Test", code: 0)
            client.complete(with: clientError)
        }
    }

    func test_load_deliversErrorOnNon200HTTPResponse() {
        let (sut, client) = makeSUT()

        let samples = [199, 201, 300, 400, 500]

        samples.enumerated().forEach { index, code in
            expect(sut, toCompleteWithResult: .failure(.invalidData)) {
                client.complete(withStatusCode: code, at: index)
            }
        }
    }

    func test_load_deliversErrorOn200HTTPResponseWithInvalidJSON() {
        let (sut, client) = makeSUT()

        expect(sut, toCompleteWithResult: .failure(.invalidData)) {
            let invalidJSON = Data("invalid json".utf8)
            client.complete(withStatusCode: 200, data: invalidJSON)
        }
    }

    func test_load_deliversDetailItemOn200HTTPResponseWithJSONDetail() {
        let (sut, client) = makeSUT()

        let (item, json) = makeItems()
                
        expect(sut, toCompleteWithResult: .success(item)) {
            let jsonDetail = try! JSONSerialization.data(withJSONObject: json)
            client.complete(withStatusCode: 200, data: jsonDetail)
        }
    }

    func test_load_doesNotDeliverResultAfterSUTInstanceHasBeenDeallocated() {
        let url = URL(string: "http://any-url.com")!
        let client = HTTPClientSpy()
        var sut: PokemonDetailLoader? = PokemonDetailLoader(url: url, client: client)

        var capturedResults = [PokemonDetailLoader.Result]()
        sut?.load { capturedResults.append($0) }

        sut = nil
        let emptyListJSON = Data("{}".utf8)
        client.complete(withStatusCode: 200, data: emptyListJSON)

        XCTAssertTrue(capturedResults.isEmpty)
    }

    // MARK: Helpers
    func makeSUT(url: URL = URL(string: "http://a-valid.url.com")!,
                 file: StaticString = #filePath, line: UInt = #line) -> (sut: PokemonDetailLoader, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = PokemonDetailLoader(url: url, client: client)
        trackForMemoryLeaks(sut, file: file, line: line)
        trackForMemoryLeaks(client, file: file, line: line)
        return (sut, client)
    }
    
    private func expect(_ sut: PokemonDetailLoader,
                        toCompleteWithResult result: PokemonDetailLoader.Result,
                        when action: () -> Void, file: StaticString = #file, line: UInt = #line) {
        
        var capturedResults = [PokemonDetailLoader.Result]()
        sut.load { capturedResults.append($0) }
        
        action()
        
        XCTAssertEqual(capturedResults, [result], file: file, line: line)
    }
    
    private func makeItems() -> (detail: DetailItem, json: [String: Any]) {
        let stat1 = Stats(baseStats: 1, name: "a stat")
        let stat1JSON: [String: Any] = [
            "base_stat": stat1.baseStats,
            "stat": [
                "name": stat1.name
            ]
        ]
        let stat2 = Stats(baseStats: 2, name: "another stat")
        let stat2JSON: [String: Any] = [
            "base_stat": stat2.baseStats,
            "stat": [
                "name": stat2.name
            ]
        ]
        
        let type1 = Types(slot: 1, name: "a type")
        let type1JSON: [String: Any] = [
            "slot": type1.slot,
            "type": [
                "name": type1.name
            ]
        ]

        let type2 = Types(slot: 2, name: "another type")
        let type2JSON: [String: Any] = [
            "slot": type2.slot,
            "type": [
                "name": type2.name
            ]
        ]

        let item = DetailItem(id: 1, name: "a name", image: "http://a-valid-url.com", stats: [stat1, stat2], types: [type1, type2])
        let json: [String: Any] = [
            "id": 1,
            "name": item.name,
            "sprites": ["front_default": item.image],
            "stats": [stat1JSON, stat2JSON],
            "types": [type1JSON, type2JSON]
        ]
        return (item, json)
    }    
}
