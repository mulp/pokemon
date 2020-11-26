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

struct ListViewModel {
    
    enum State: Equatable {
        case listLoaded
        case listFetched([ListItem])
        case listFetchError(PokemonListLoader.Error)
        case listSuccessfullyLoaded
    }
    
    var performRequest = PublishRelay<Void>()
    
    var state: Observable<State> {
        Observable.merge(
            fetchList(),
            .just(.listLoaded)
        )
    }
    private let loader: ListLoader
    
    init(with loader: ListLoader) {
        self.loader = loader
    }
    
    func fetchList() -> Observable<State> {
        performRequest
            .flatMap { _ in
                self.makeRequestFetchList().asObservable().materialize()
            }
            .compactMap { event in
                switch event {
                case .next(let repos):
                    return .listFetched(repos)
                case .error:
                    return .listFetchError(PokemonListLoader.Error.invalidData)
                case .completed:
                    return .listSuccessfullyLoaded
                }
            }
    }
        
    func makeRequestFetchList() -> Single<[ListItem]> {
        return Single<[ListItem]>.create { observer in
            loader.load { result in
                switch result {
                case let .success(items):
                    observer(.success(items))
                case let .failure(error):
                    observer(.error(error))
                }
            }
            return Disposables.create()
        }
    }
}

class ListViewModelTests: XCTestCase {

    func test_initialState() {
        let (_, state) = makeSUT()

        XCTAssertEqual(state.values, [.listLoaded])
    }
    
    func test_performedRequest_includeRepoList() {
        let (sut, state) = makeSUT()
        
        sut.performRequest.accept(())
        
        XCTAssertEqual(state.values, [ .listLoaded, .listFetched(PokemonListStub.items), .listSuccessfullyLoaded])
    }
    
    // MARK: Helpers
    private func makeSUT() -> (sut: ListViewModel, state: StateSpy) {
        let loader = PokemonListLoaderStub()
        let sut = ListViewModel(with: loader)
        let state = StateSpy(sut.state)
        return (sut, state)
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
    }
    
    private class PokemonListStub {
        private static let item1 = ListItem(name: "a name", image: URL(string: "http://a-valid-url.com")!)
        private static let item2 = ListItem(name: "another name", image: URL(string: "http://a-valid-url.com")!)

        static var items: [ListItem] {
            return [item1, item2]
        }
    }
}
