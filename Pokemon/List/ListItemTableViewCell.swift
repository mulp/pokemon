//
//  ListItemTableViewCell.swift
//  Pokemon
//
//  Created by Fabio Cuomo on 26/11/2020.
//

import UIKit

class ListItemTableViewCell: UITableViewCell {
    static let Identifier = "ListItemCellIdentifier"
    
    private let avatarImage: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleToFill
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.textColor = .black
        return label
    }()
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubiews()
        setUpConstraints()
        contentView.backgroundColor = .white
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    private func addSubiews() {
        [avatarImage, nameLabel].forEach {
            stackView.addArrangedSubview($0)
        }
        contentView.addSubview(stackView)
    }
    
    private func setUpConstraints() {
        NSLayoutConstraint.activate([
            avatarImage.widthAnchor.constraint(equalToConstant: 30),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5.0),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10.0),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10.0),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5.0),
        ])
    }
    
    func configure(with item: ListItem) {
        avatarImage.download(from: item.image)
        nameLabel.text = item.name
    }
}
