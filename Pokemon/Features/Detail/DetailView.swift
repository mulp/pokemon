//
//  DetailView.swift
//  Pokemon
//
//  Created by Fabio Cuomo on 26/11/2020.
//

import UIKit

final class DetailView: UIView {
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()

    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleToFill
        return imageView
    }()

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.numberOfLines = 2
        return label
    }()

    private let statsHeaderLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 26, weight: .bold)
        label.numberOfLines = 1
        label.text = NSLocalizedString("Stats", comment: "")
        return label
    }()

    private let statsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .fillProportionally
        return stackView
    }()

    private let typesHeaderLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 26, weight: .bold)
        label.numberOfLines = 1
        label.text = NSLocalizedString("Types", comment: "")
        return label
    }()

    private let typesStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .fillProportionally
        return stackView
    }()

    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView()
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.hidesWhenStopped = true
        return spinner
    }()
    
    init() {
        super.init(frame: .zero)
        setupSubviews()
        setupConstraints()
        backgroundColor = .white
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    // MARK: - Private methods
    private func setupSubviews() {
        [imageView, nameLabel, statsHeaderLabel, statsStackView, typesHeaderLabel, typesStackView, spinner].forEach(addSubview)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 200),
            
            nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            nameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20),
            nameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            
            statsHeaderLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            statsHeaderLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 20),
            statsHeaderLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),

            statsStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            statsStackView.topAnchor.constraint(equalTo: statsHeaderLabel.bottomAnchor, constant: 20),
            statsStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),

            typesHeaderLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            typesHeaderLabel.topAnchor.constraint(equalTo: statsStackView.bottomAnchor, constant: 20),
            typesHeaderLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),

            typesStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            typesStackView.topAnchor.constraint(equalTo: typesHeaderLabel.bottomAnchor, constant: 20),
            typesStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            
            spinner.centerXAnchor.constraint(equalTo: centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }

    private func addStats(_ stats: [Stats]) {
        if !stats.isEmpty {
            let header = TwoColumnView()
            header.configure(with: NSLocalizedString("Name", comment: ""),
                             rightValue: NSLocalizedString("Base Stats", comment: ""),
                             fontBold: true)
            statsStackView.addArrangedSubview(header)
            stats.forEach { [statsStackView] stats in
                let row = TwoColumnView()
                row.configure(with: stats.name, rightValue: String(stats.baseStats))
                row.layoutIfNeeded()
                statsStackView.addArrangedSubview(row)
            }
        }
    }

    private func addTypes(_ types: [Types]) {
        if !types.isEmpty {
            let header = TwoColumnView()
            header.configure(with: NSLocalizedString("Slot", comment: ""),
                             rightValue: NSLocalizedString("Name", comment: ""),
                             fontBold: true)
            typesStackView.addArrangedSubview(header)
            types.forEach { [typesStackView] types in
                let row = TwoColumnView()
                row.configure(with: types.name, rightValue: String(types.slot))
                row.layoutIfNeeded()
                typesStackView.addArrangedSubview(row)
            }
        }
    }

    // MARK: - Public methods
    func configure(with model: DetailItem) {
        imageView.download(from: model.image)
        nameLabel.text = model.name.prefix(1).uppercased() + model.name.dropFirst()
        addStats(model.stats)
        addTypes(model.types)
    }
    
    func loading() {
        spinner.startAnimating()
    }
    
    func loadComplete() {
        spinner.stopAnimating()
    }
}
