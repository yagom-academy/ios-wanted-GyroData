//
//  CustomTableViewCell.swift
//  GyroData
//
//  Created by Mangdi on 2023/01/30.
//

import UIKit

class CustomTableViewCell: UITableViewCell {

    // MARK: - Property
    let dateView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.text = "test"
        return textView
    }()

    let sensorTypeView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.font = UIFont.systemFont(ofSize: 30)
        return textView
    }()

    let runningTimeView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.font = UIFont.systemFont(ofSize: 60)
        return textView
    }()

    let verticalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .fill
        return stackView
    }()

    // MARK: - Method
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        configureSubViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureSubViews() {
        verticalStackView.addArrangedSubview(dateView)
        verticalStackView.addArrangedSubview(sensorTypeView)
        contentView.addSubview(verticalStackView)
        contentView.addSubview(runningTimeView)

        NSLayoutConstraint.activate([
            verticalStackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            verticalStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            verticalStackView.trailingAnchor.constraint(equalTo: runningTimeView.leadingAnchor),
            verticalStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            runningTimeView.topAnchor.constraint(equalTo: contentView.topAnchor),
            runningTimeView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            runningTimeView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}
