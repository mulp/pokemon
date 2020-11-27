//
//  TwoColumnView.swift
//  Pokemon
//
//  Created by Fabio Cuomo on 26/11/2020.
//

import UIKit

final class TwoColumnView: UIView {
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fill
        return stackView
    }()

    private let leftColumnLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.numberOfLines = 1
        return label
    }()

    private let rightColumnLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.numberOfLines = 1
        return label
    }()
    
    private let spacer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
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
        stackView.addArrangedSubview(leftColumnLabel)
        stackView.addArrangedSubview(rightColumnLabel)
        addSubview(stackView)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            leftColumnLabel.widthAnchor.constraint(equalToConstant: 150)
        ])
    }
    
    // MARK: - Public methods
    func configure(with leftValue: String, rightValue: String, fontBold: Bool = false) {
        leftColumnLabel.font = UIFont.systemFont(ofSize: 16, weight: fontBold ? .bold : .regular)
        rightColumnLabel.font = UIFont.systemFont(ofSize: 16, weight: fontBold ? .bold : .regular)
        leftColumnLabel.text = leftValue
        rightColumnLabel.text = rightValue
    }
}
