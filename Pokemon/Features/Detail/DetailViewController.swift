//
//  DetailViewController.swift
//  Pokemon
//
//  Created by Fabio Cuomo on 27/11/2020.
//

import UIKit
import RxSwift
import RxCocoa

class DetailViewController: UIViewController {
    private let rootView = DetailView()
    
    private var viewModel: DetailViewModel?
    private let disposeBag = DisposeBag()
    
    public convenience init(viewModel: DetailViewModel) {
        self.init()
        self.viewModel = viewModel
    }

    override func loadView() {
        self.view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBinding()
        viewModel?.performRequest.accept(())
        view.backgroundColor = .white
        title = NSLocalizedString("Pokemon Detail", comment: "")
    }

    // MARK: - Private methods
    private func setupBinding() {
        guard let viewModel = viewModel else { return }

        viewModel
            .state
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] state in
                self?.react(on: state)
            }, onCompleted: { [weak self] in
                self?.rootView.loadComplete()
            })
            .disposed(by: disposeBag)
    }
    
    private func react(on state: DetailViewModel.State) {
        switch state {
        case .detailLoaded:
            self.rootView.loading()
            return
        case .detailFetched(let detail):
            rootView.configure(with: detail)
        case .detailFetchError(let error):
            self.showError(error: error)
        case .detailSuccessfullyLoaded:
            self.rootView.loadComplete()
        }
        self.rootView.loadComplete()
    }
}
