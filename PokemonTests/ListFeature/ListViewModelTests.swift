//
//  ListViewModelTests.swift
//  PokemonTests
//
//  Created by Fabio Cuomo on 25/11/2020.
//

import XCTest

struct ListViewModel {
    
    enum State {
        case screenLoaded
    }
    
    var state: State = .screenLoaded
}

class ListViewModelTests: XCTestCase {

    func test_initialState() {
        let sut = ListViewModel()
        
        XCTAssertEqual(sut.state, .screenLoaded)
    }
    
}
