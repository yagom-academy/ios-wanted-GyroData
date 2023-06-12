//
//  GyroListCell.swift
//  GyroData
//
//  Created by kokkilE on 2023/06/12.
//

import UIKit

final class GyroListCell: UITableViewCell {
    private let mainStackView = {
        let stackView = UIStackView()
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        stackView.layoutMargins = UIEdgeInsets(top: 12, left: 20, bottom: 12, right: 20)
        stackView.isLayoutMarginsRelativeArrangement = true
        
        return stackView
    }()
    
    private let stackView = {
        let stackView = UIStackView()
        
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .equalSpacing
        stackView.spacing = 20
        
        return stackView
    }()
    
    private let dateLabel = {
        let label = UILabel()
        
        label.font = .preferredFont(forTextStyle: .body)
        
        return label
    }()
    
    private let typeLabel = {
        let label = UILabel()
        
        label.font = .preferredFont(forTextStyle: .title2)
        
        return label
    }()
    
    private let durationLabel = {
        let label = UILabel()
        
        label.font = .systemFont(ofSize: 40, weight: .bold, width: .standard)
        
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupCell()
        addSubviews()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(date: String, type: String, duration: String) {
        dateLabel.text = date
        typeLabel.text = type
        durationLabel.text = duration
    }
    
    private func setupCell() {
        backgroundColor = .systemBackground
    }
    
    private func addSubviews() {
        stackView.addArrangedSubview(dateLabel)
        stackView.addArrangedSubview(typeLabel)
        
        mainStackView.addArrangedSubview(stackView)
        mainStackView.addArrangedSubview(durationLabel)
        
        addSubview(mainStackView)
    }
    
    private func layout() {
        let safe = safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: safe.topAnchor, constant: 4),
            mainStackView.leadingAnchor.constraint(equalTo: safe.leadingAnchor, constant: 4),
            mainStackView.trailingAnchor.constraint(equalTo: safe.trailingAnchor, constant: -4),
            mainStackView.bottomAnchor.constraint(equalTo: safe.bottomAnchor, constant: -4)
        ])
    }
}
