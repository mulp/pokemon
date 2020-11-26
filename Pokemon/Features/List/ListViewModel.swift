//
//  ListViewModel.swift
//  Pokemon
//
//  Created by Fabio Cuomo on 26/11/2020.
//

import Foundation
import RxCocoa
import RxSwift

public struct ListViewModel {
    
    public enum State: Equatable {
        case listLoaded
        case listFetched([ListItem])
        case listFetchError(PokemonListLoader.Error)
        case listSuccessfullyLoaded
    }
    
    public var performRequest = PublishRelay<Void>()
    
    public var state: Observable<State> {
        Observable.merge(
            fetchList(),
            .just(.listLoaded)
        )
    }
    private let loader: ListLoader
    
    public init(with loader: ListLoader) {
        self.loader = loader
    }
    
    public func fetchList() -> Observable<State> {
        performRequest
            .flatMap { _ in
                self.makeRequestFetchList().asObservable().materialize()
            }
            .compactMap { event in
                switch event {
                case .next(let repos):
                    return .listFetched(repos)
                case .error(let error):
                    return .listFetchError(error as? PokemonListLoader.Error ?? PokemonListLoader.Error.unknown)
                case .completed:
                    return .listSuccessfullyLoaded
                }
            }
    }
        
    private func makeRequestFetchList() -> Single<[ListItem]> {
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

