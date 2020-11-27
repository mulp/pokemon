//
//  DetailViewModel.swift
//  Pokemon
//
//  Created by Fabio Cuomo on 27/11/2020.
//

import Foundation
import RxCocoa
import RxSwift

public struct DetailViewModel {
    
    public enum State: Equatable {
        case detailLoaded
        case detailFetched(DetailItem)
        case detailFetchError(PokemonDetailLoader.Error)
        case detailSuccessfullyLoaded
    }
    
    public var performRequest = PublishRelay<Void>()
    
    public var state: Observable<State> {
        Observable.merge(
            fetchDetail(),
            .just(.detailLoaded)
        )
    }
    private let loader: DetailLoader
    
    public init(with loader: DetailLoader) {
        self.loader = loader
    }
    
    public func fetchDetail() -> Observable<State> {
        performRequest
            .flatMap { _ in
                self.makeRequestFetchDetail().asObservable().materialize()
            }
            .compactMap { event in
                switch event {
                case .next(let detail):
                    return .detailFetched(detail)
                case .error(let error):
                    return .detailFetchError(error as? PokemonDetailLoader.Error ?? PokemonDetailLoader.Error.unknown)
                case .completed:
                    return .detailSuccessfullyLoaded
                }
            }
    }
        
    private func makeRequestFetchDetail() -> Single<DetailItem> {
        return Single<DetailItem>.create { observer in
            loader.load { result in
                switch result {
                case let .success(detail):
                    observer(.success(detail))
                case let .failure(error):
                    observer(.error(error))
                }
            }
            return Disposables.create()
        }
    }
}


