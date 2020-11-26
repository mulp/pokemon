//
//  ListViewModelTests.swift
//  PokemonTests
//
//  Created by Fabio Cuomo on 25/11/2020.
//

import XCTest
import RxCocoa
import RxSwift
import Pokemon

class ListViewModelTests: XCTestCase {

    func test_initialState() {
        let (_, state, _) = makeSUT()

        XCTAssertEqual(state.values, [.listLoaded])
    }
    
    func test_performedRequest_includeRepoList() {
        let (sut, state, _) = makeSUT()
        
        sut.performRequest.accept(())
        
        XCTAssertEqual(state.values, [ .listLoaded, .listFetched(PokemonListStub.items), .listSuccessfullyLoaded])
    }
    
    func test_performedRequestError_movesToErrorState() {
        let (sut, state, loader) = makeSUT()
        let error: PokemonListLoader.Error = .invalidData
        loader.complete(with: error)
        
        sut.performRequest.accept(())
        
        XCTAssertEqual(state.values, [ .listLoaded, .listFetchError(error)])
    }

    // MARK: Helpers
    private func makeSUT() -> (sut: ListViewModel, state: StateSpy, loader: PokemonListLoaderStub) {
        let loader = PokemonListLoaderStub()
        let sut = ListViewModel(with: loader)
        let state = StateSpy(sut.state)
        return (sut, state, loader)
    }
    
    class StateSpy {
        private(set) var values = [ListViewModel.State]()
        private let disposeBag = DisposeBag()
        
        init(_ observable: Observable<ListViewModel.State>) {
            observable.subscribe(onNext: { state in
                self.values.append(state)
            })
            .disposed(by: disposeBag)
        }
    }
    
    class PokemonListLoaderStub: ListLoader {
        var loaderError: PokemonListLoader.Error?

        func load(completion: @escaping (PokemonListLoader.Result) -> Void) {
            if let loaderError = loaderError {
                return completion(.failure(loaderError))
            } else {
                return completion(.success(PokemonListStub.items))
            }
        }
        
        func complete(with error: PokemonListLoader.Error) {
            loaderError = error
        }
    }
    
    private class PokemonListStub {
        private static let item1 = ListItem(name: "a name", targetURL: URL(string: "http://a-valid-url.com")!)
        private static let item2 = ListItem(name: "another name", targetURL: URL(string: "http://a-valid-url.com")!)

        static var items: [ListItem] {
            return [item1, item2]
        }
    }
}
