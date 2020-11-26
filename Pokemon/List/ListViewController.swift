//
//  ListViewController.swift
//  Pokemon
//
//  Created by Fabio Cuomo on 23/11/2020.
//

//
//  RepoListViewController.swift
//  XingTest
//
//  Created by Fabio Cuomo on 20/08/2020.
//

import UIKit
import RxSwift
import RxCocoa

class ListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.alpha = 1
        tableView.rowHeight = 50.0
        return tableView
    }()
    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView()
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.hidesWhenStopped = true
        return spinner
    }()
    private var viewModel: ListViewModel?
    private let disposeBag = DisposeBag()
    private var dataSource: [ListItem] = []
    
    public convenience init(viewModel: ListViewModel) {
        self.init()
        self.viewModel = viewModel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubviews()
        setupConstraints()
        configureTableView()
        viewModel?.performRequest.accept(())
        view.backgroundColor = .white
        title = NSLocalizedString("Pokemon List", comment: "")
    }

    // MARK: - Private methods
    private func configureTableView() {
        guard let viewModel = viewModel else { return }

        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(ListItemTableViewCell.self, forCellReuseIdentifier: ListItemTableViewCell.Identifier)

        viewModel
            .state
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] state in
                self?.react(on: state)
            }, onCompleted: { [weak self] in
                self?.spinner.stopAnimating()
                self?.tableView.alpha = 1
            })
            .disposed(by: disposeBag)
    }
    
    private func react(on state: ListViewModel.State) {
        switch state {
        case .listLoaded:
            self.spinner.startAnimating()
            return
        case .listFetched(let items):
            self.dataSource = items
            self.tableView.reloadData()
        case .listFetchError(let error):
            self.showError(error: error)
        case .listSuccessfullyLoaded:
            self.spinner.stopAnimating()
            self.tableView.alpha = 1
        }
        self.spinner.stopAnimating()
    }
    
    private func setupSubviews() {
        view.addSubview(tableView)
        view.addSubview(spinner)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    // MARK: - UITableView Datasource methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ListItemTableViewCell.Identifier, for: indexPath) as? ListItemTableViewCell else {
            return UITableViewCell()
        }
        let item = dataSource[indexPath.row]
        cell.configure(with: item)
        cell.accessoryType = .none
        return cell
    }
    
    // MARK: - UITableView Delegate methods
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false
    }
}
