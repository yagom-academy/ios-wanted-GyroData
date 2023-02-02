//
//  ListTableViewCell.swift
//  GyroData
//
//  Created by ash and som on 2023/02/01.
//

import UIKit

class ListTableViewCell: UITableViewCell {
    private let mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let subStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .body, compatibleWith: .none)
        return label
    }()
    
    private let gyroModeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .subheadline, compatibleWith: .none)
        return label
    }()
    
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .largeTitle, compatibleWith: .none)
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureLayout() {
        mainStackView.addArrangedSubview(subStackView)
        mainStackView.addArrangedSubview(timeLabel)
        
        subStackView.addArrangedSubview(dateLabel)
        subStackView.addArrangedSubview(gyroModeLabel)
        
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            mainStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            mainStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            mainStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    func configureCell(_ data: GyroInformationModel) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .medium
        
        dateLabel.text = dateFormatter.string(from: data.date)
        
        if data.graphMode == .gyro {
            gyroModeLabel.text = "Gyro"
        } else {
            gyroModeLabel.text = "Accelerometer"
        }
        
        timeLabel.text = data.time.description
    }
}
