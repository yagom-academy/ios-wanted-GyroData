//
//  MotionDataCell.swift
//  GyroData
//
//  Created by inho on 2023/02/03.
//

import UIKit

final class MotionDataCell: UITableViewCell {
    static let identifier = String(describing: MotionDataCell.self)
    
    private let leftStackView: UIStackView = {
        let stackView = UIStackView()
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        
        return stackView
    }()
    private let measuredDateLabel: UILabel = {
        let label = UILabel()
        
        label.setContentHuggingPriority(.defaultHigh, for: .vertical)
        
        return label
    }()
    private let typeLabel: UILabel = {
        let label = UILabel()
        
        label.font = .preferredFont(forTextStyle: .title2)
        
        return label
    }()
    private let durationLabel: UILabel = {
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .largeTitle)
        
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureStackView()
        configureContentView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureStackView() {
        [measuredDateLabel, typeLabel].forEach {
            leftStackView.addArrangedSubview($0)
        }
    }
    
    private func configureContentView() {
        [leftStackView, durationLabel].forEach {
            contentView.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            leftStackView.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor,
                constant: 40
            ),
            leftStackView.trailingAnchor.constraint(
                equalTo: durationLabel.leadingAnchor,
                constant: -60
            ),
            leftStackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            leftStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            durationLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            durationLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            durationLabel.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor,
                constant: -20
            )
        ])
    }
}
