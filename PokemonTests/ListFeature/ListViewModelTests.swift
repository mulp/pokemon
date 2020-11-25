//
//  ListViewModelTests.swift
//  PokemonTests
//
//  Created by Fabio Cuomo on 25/11/2020.
//

import XCTest
import RxCocoa
import RxSwift

struct ListViewModel {
    
    enum State {
        case screenLoaded
        case listFetched
    }
    
    var performRequest = PublishRelay<Void>()
    
    var state: Observable<State> {
        Observable.merge(
            performRequest.map { _ in .listFetched },
            .just(.screenLoaded)
        )
    }
}

class ListViewModelTests: XCTestCase {

    func test_initialState() {
        let sut = ListViewModel()
        let state = StateSpy(sut.state)

        XCTAssertEqual(state.values, [.screenLoaded])
    }
    
    func test_performedRequest_includeRepoList() {
        let sut = ListViewModel()
        let state = StateSpy(sut.state)
        
        sut.performRequest.accept(())
        
        XCTAssertEqual(state.values, [.screenLoaded, .listFetched])
    }
    
    // MARK: Helpers
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
}
