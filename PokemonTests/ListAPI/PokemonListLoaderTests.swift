//
//  PokemonListLoaderTests.swift
//  PokemonTests
//
//  Created by Fabio Cuomo on 23/11/2020.
//

import XCTest
import Pokemon

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

    func test_load_deliversNoItemsOn200HTTPResponseWithEmptyJSONList() {
        let (sut, client) = makeSUT()

        expect(sut, toCompleteWithResult: .success([])) {
            let emptyListJSON = Data("{\"results\": []}".utf8)
            client.complete(withStatusCode: 200, data: emptyListJSON)
        }
    }

    func test_load_deliversItemsOn200HTTPResponseWithJSONList() {
        let (sut, client) = makeSUT()

        let item1 = ListItem(name: "a name", targetURL: URL(string: "http://a-valid-url.com")!)
        let item1JSON = [
            "name": item1.name,
            "url": item1.targetURL?.absoluteString
        ]
        
        let item2 = ListItem(name: "another name", targetURL: URL(string: "http://a-valid-url.com")!)
        let item2JSON = [
            "name": item2.name,
            "url": item2.targetURL?.absoluteString
        ]

        let json = ["results": [item1JSON, item2JSON]]
        
        expect(sut, toCompleteWithResult: .success([item1, item2])) {
            let jsonList = try! JSONSerialization.data(withJSONObject: json)
            client.complete(withStatusCode: 200, data: jsonList)
        }
    }

    func test_load_doesNotDeliverResultAfterSUTInstanceHasBeenDeallocated() {
        let url = URL(string: "http://any-url.com")!
        let client = HTTPClientSpy()
        var sut: PokemonListLoader? = PokemonListLoader(url: url, client: client)

        var capturedResults = [PokemonListLoader.Result]()
        sut?.load { capturedResults.append($0) }

        sut = nil
        let emptyListJSON = Data("{\"results\": []}".utf8)
        client.complete(withStatusCode: 200, data: emptyListJSON)

        XCTAssertTrue(capturedResults.isEmpty)
    }

    // MARK: Helpers
    func makeSUT(url: URL = URL(string: "http://a-valid.url.com")!,
                 file: StaticString = #filePath, line: UInt = #line) -> (sut: PokemonListLoader, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = PokemonListLoader(url: url, client: client)
        trackForMemoryLeaks(sut, file: file, line: line)
        trackForMemoryLeaks(client, file: file, line: line)
        return (sut, client)
    }
    
    private func expect(_ sut: PokemonListLoader,
                        toCompleteWithResult result: PokemonListLoader.Result,
                        when action: () -> Void, file: StaticString = #file, line: UInt = #line) {
        
        var capturedResults = [PokemonListLoader.Result]()
        sut.load { capturedResults.append($0) }
        
        action()
        
        XCTAssertEqual(capturedResults, [result], file: file, line: line)
    }
    
    class HTTPClientSpy: HTTPClient {
        private var messages = [(url: URL, completion: (HTTPClientResult) -> Void)]()
        
        var requestedURLs: [URL] {
            messages.map { $0.url }
        }
        
        func get(from url: URL, completion: @escaping (HTTPClientResult) -> Void) {
            messages.append((url, completion))
        }
        
        func complete(with error: Error, at index: Int = 0) {
            messages[index].completion(.failure(error))
        }
        
        func complete(withStatusCode code: Int, data: Data = Data(), at index: Int = 0) {
            let response = HTTPURLResponse(
                url: requestedURLs[index],
                statusCode: code,
                httpVersion: nil,
                headerFields: nil
            )!
            messages[index].completion(.success(data, response))
        }
    }
}
