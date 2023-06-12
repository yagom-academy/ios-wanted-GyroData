//
//  GryoListCell.swift
//  GyroData
//
//  Created by kokkilE on 2023/06/12.
//

import UIKit

final class GryoListCell: UITableViewCell {
    private let mainStackView = {
        let stackView = UIStackView()
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .leading
        stackView.distribution = .equalSpacing
        
        return stackView
    }()
    
    private let stackView = {
        let stackView = UIStackView()
        
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .equalSpacing
        
        return stackView
    }()
    
    private let dateLabel = {
        let label = UILabel()
        
        label.font = .preferredFont(forTextStyle: .body)
        label.text = "TEST DATE"
        
        return label
    }()
    
    private let typeLabel = {
        let label = UILabel()
        
        label.font = .preferredFont(forTextStyle: .title2)
        label.text = "TEST typeLabel"
        
        return label
    }()
    
    private let durationLabel = {
        let label = UILabel()
        
        label.font = .boldSystemFont(ofSize: 40)
        label.text = "60.0"
        
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
    
    
    private func setupCell() {
        backgroundColor = .systemBackground
    }
    
    private func addSubviews() {
        stackView.addArrangedSubview(dateLabel)
        stackView.addArrangedSubview(typeLabel)
        
        mainStackView.addArrangedSubview(stackView)
        mainStackView.addArrangedSubview(durationLabel)
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
