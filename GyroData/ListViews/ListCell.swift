//
//  ListCell.swift
//  GyroData
//
//  Created by 써니쿠키, 로빈 on 2023/01/30.
//

import UIKit

final class ListCell: UITableViewCell {
    
    static var reuseIdentifier: String {
           return String(describing: self)
       }
    
    private let dateLabel = UILabel(font: .body)
    private let sensorNameLabel = UILabel(font: .title2)
    private let valueLabel = UILabel(font: .largeTitle, textAlignment: .center)
    private let verticalStackView = UIStackView(axis: .vertical,
                                                distribution: .fill,
                                                alignment: .fill,
                                                spacing: 20)
    private let totalStackView = UIStackView(distribution: .fill,
                                             alignment: .center,
                                             margin: 20)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureHierarchy()
        configureLayout()
    }
    
    func setup(date: String, sensorName: String, value: String) {
        dateLabel.text = date
        sensorNameLabel.text = sensorName
        valueLabel.text = value
    }
    
    private func configureHierarchy() {
        [dateLabel, sensorNameLabel].forEach { label in
            verticalStackView.addArrangedSubview(label)
        }
        
        [verticalStackView, valueLabel].forEach { view in
            totalStackView.addArrangedSubview(view)
        }
        
        contentView.addSubview(totalStackView)
    }
    
    private func configureLayout() {
        NSLayoutConstraint.activate([
            totalStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            totalStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            totalStackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            totalStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            valueLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.3)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
