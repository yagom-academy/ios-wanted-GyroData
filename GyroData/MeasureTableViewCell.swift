//  GyroData - MeasureTableViewCell.swift
//  Created by zhilly, woong on 2023/01/31

import UIKit

final class MeasureTableViewCell: UITableViewCell, ReusableView {
    
    private let createdAtLabel: UILabel = {
        let label = UILabel()
        
        label.textAlignment = .left
        label.font = .preferredFont(forTextStyle: .footnote)
        label.textColor = .black
        
        return label
    }()
    
    private let sensorTypeLabel: UILabel = {
        let label = UILabel()
        
        label.textAlignment = .left
        label.font = .preferredFont(forTextStyle: .title2)
        label.textColor = .black
        
        return label
    }()
    
    private let measurementTimeLabel: UILabel = {
        let label = UILabel()
        
        label.textAlignment = .center
        label.font = .preferredFont(forTextStyle: .largeTitle)
        label.textColor = .black
        
        return label
    }()
    
    private let verticalStackView: UIStackView = {
        let stackView = UIStackView()
        
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    private let horizontalStackView: UIStackView = {
        let stackView = UIStackView()
        
        stackView.axis = .horizontal
        stackView.spacing = 16
        stackView.distribution = .equalSpacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        [createdAtLabel, sensorTypeLabel].forEach(verticalStackView.addArrangedSubview(_:))
        [verticalStackView, measurementTimeLabel].forEach(horizontalStackView.addArrangedSubview(_:))
        contentView.addSubview(horizontalStackView)
        
        // TODO: - Layout 수정
        NSLayoutConstraint.activate([
            horizontalStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            horizontalStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 30),
            horizontalStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -30),
            horizontalStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
        ])
    }
    
    func configure() {
        createdAtLabel.text = "2022/09/08 13:23:43"
        sensorTypeLabel.text = "Accelerometer"
        measurementTimeLabel.text = "40.3"
    }
}
