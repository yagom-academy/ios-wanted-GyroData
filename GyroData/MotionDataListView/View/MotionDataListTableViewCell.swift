//
//  MotionDataListTableViewCell.swift
//  GyroData
//
//  Created by junho on 2023/02/01.
//

import UIKit

class MotionDataListTableViewCell: UITableViewCell {
    enum Constant {
        enum Layout {
            static let stackViewSpacing: CGFloat = 10
            static let padding: CGFloat = 10
        }
    }
    
    static let identifier = "ListCell"

    let createdAtLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.adjustsFontForContentSizeCategory = true
        return label
    }()

    let typeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .title1)
        label.adjustsFontForContentSizeCategory = true
        return label
    }()

    let lengthLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .largeTitle)
        label.adjustsFontForContentSizeCategory = true
        return label
    }()

    let verticalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = Constant.Layout.stackViewSpacing
        return stackView
    }()

    let horizontalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = Constant.Layout.stackViewSpacing
        return stackView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureHierarchy()
        configureLayout()
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
    }
    
    private func configureLayout() {
        createdAtLabel.setContentHuggingPriority(.defaultHigh, for: .vertical)
        lengthLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        lengthLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        NSLayoutConstraint.activate([
            horizontalStackView.topAnchor.constraint(equalTo: topAnchor, constant: Constant.Layout.padding),
            horizontalStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constant.Layout.padding * 2),
            horizontalStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constant.Layout.padding * 2),
            horizontalStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Constant.Layout.padding)
        ])
    }

    func configureSubviewsText(createdAt: String, type: String, length: String) {
        createdAtLabel.text = createdAt
        typeLabel.text = type
        lengthLabel.text = length
    }
}
