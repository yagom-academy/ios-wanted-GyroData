//
//  MainTableViewCell.swift
//  GyroData
//
//  Created by 백곰, 바드 on 2022/12/26.
//

import UIKit

final class MainTableViewCell: UITableViewCell {
    
    // MARK: Properties
    
    private let verticalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.spacing = 20
        return stackView
    }()
    
    private let horizontalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        return stackView
    }()
    
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.font = .systemFont(ofSize: 12, weight: .semibold)
        return label
    }()
    
    private let typeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.font = .systemFont(ofSize: 24, weight: .bold)
        return label
    }()
    
    private let typeMeasurementLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.font = .systemFont(ofSize: 30, weight: .bold)
        return label
    }()
    
    // MARK: - Initializers
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        commonInit()
    }
}

extension MainTableViewCell: ReuseIdentifying {
    // MARK: - Methods
    
    func setupTimeLabelText(_ text: String) {
        timeLabel.text = text
    }
    
    func setupTypeLabelText(_ text: String) {
        typeLabel.text = text
    }
    
    func setupTypeMeasurementLabelText(_ text: String) {
        typeMeasurementLabel.text = text
    }
    
    private func commonInit() {
        setupSubview()
        setupConstraint()
    }
    
    private func setupSubview() {
        [timeLabel, typeLabel]
            .forEach { verticalStackView.addArrangedSubview($0) }
        [verticalStackView, typeMeasurementLabel]
            .forEach { horizontalStackView.addArrangedSubview($0) }
        addSubview(horizontalStackView)
    }
    
    private func setupConstraint() {
        setupHorizontalStacViewConstraint()
    }
    
    private func setupHorizontalStacViewConstraint() {
        NSLayoutConstraint.activate([
            horizontalStackView.centerYAnchor.constraint(
                equalTo: centerYAnchor
            ),
            horizontalStackView.leadingAnchor.constraint(
                equalTo: leadingAnchor,
                constant: 40
            ),
            horizontalStackView.trailingAnchor.constraint(
                equalTo: trailingAnchor,
                constant: -40
            )
        ])
    }
    
    func configure(with data: GyroModel) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        timeLabel.text = dateFormatter.string(from: Date(timeIntervalSince1970: data.createdAt))
        
        if data.motionType == "accelerometer" {
            typeLabel.text = "Accelerometer"
        } else {
            typeLabel.text = "Gyro"
        }
        
        typeMeasurementLabel.text = "60"
    }
}
