//
//  MotionDataListTableViewCell.swift
//  GyroData
//
//  Created by junho lee on 2023/02/01.
//

import UIKit

class MotionDataListTableViewCell: UITableViewCell {
    static let identifier = "ListCell"

    let createdAtLabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.adjustsFontForContentSizeCategory = true
        return label
    }()

    let typeLabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .title1)
        label.adjustsFontForContentSizeCategory = true
        return label
    }()

    let lengthLabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .largeTitle)
        label.adjustsFontForContentSizeCategory = true
        return label
    }()

    let verticalStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 10
        return stackView
    }()

    let horizontalStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 10
        return stackView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureHierarchy()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureHierarchy() {
        verticalStackView.addArrangedSubview(createdAtLabel)
        verticalStackView.addArrangedSubview(typeLabel)
        horizontalStackView.addArrangedSubview(verticalStackView)
        horizontalStackView.addArrangedSubview(lengthLabel)
        addSubview(horizontalStackView)

        createdAtLabel.setContentHuggingPriority(.defaultHigh, for: .vertical)
        lengthLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        lengthLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        let spacing = 10.0
        NSLayoutConstraint.activate([
            horizontalStackView.topAnchor.constraint(equalTo: topAnchor, constant: spacing),
            horizontalStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: spacing * 2),
            horizontalStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -spacing * 2),
            horizontalStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -spacing)
        ])
    }

    func configureSubviewsText(createdAt: String, type: String, length: String) {
        createdAtLabel.text = createdAt
        typeLabel.text = type
        lengthLabel.text = length
    }
}
