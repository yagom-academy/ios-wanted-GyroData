//
//  CustomTableViewCell.swift
//  GyroData
//
//  Created by Mangdi on 2023/01/30.
//

import UIKit

class CustomTableViewCell: UITableViewCell {

    // MARK: - Property
    let dateView: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16)
        label.text = "2022/09/08 14:50:51"
        return label
    }()

    let sensorTypeView: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 24)
        label.text = "Accelerometer"
        return label
    }()

    let runningTimeView: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 48)
        label.text = "60.0"
        label.textAlignment = .left
        return label
    }()

    let verticalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .fillEqually
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
        let leftMargin: CGFloat = contentView.frame.width/10
        verticalStackView.addArrangedSubview(dateView)
        verticalStackView.addArrangedSubview(sensorTypeView)
        contentView.addSubview(verticalStackView)
        contentView.addSubview(runningTimeView)

        NSLayoutConstraint.activate([
            verticalStackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            verticalStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            verticalStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            verticalStackView.trailingAnchor.constraint(equalTo: runningTimeView.leadingAnchor),
            runningTimeView.leadingAnchor.constraint(equalTo: verticalStackView.trailingAnchor),
            runningTimeView.topAnchor.constraint(equalTo: contentView.topAnchor),
            runningTimeView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            runningTimeView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            verticalStackView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.65),
            runningTimeView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.35)
        ])

        verticalStackView.isLayoutMarginsRelativeArrangement = true
        verticalStackView.layoutMargins = UIEdgeInsets(top: 0, left: leftMargin, bottom: 0, right: 0)
    }
}
