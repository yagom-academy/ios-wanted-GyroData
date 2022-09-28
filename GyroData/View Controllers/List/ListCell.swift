//
//  ListCell.swift
//  GyroData
//
//  Created by 신병기 on 2022/09/20.
//

import UIKit

final class ListCell: UITableViewCell {
    static var identifier: String { String(describing: self) }

    let dateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        return label
    }()
    
    let keyLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        return label
    }()
    
    let valueLabel: UILabel = {
        let label = UILabel()
        label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        label.font = .systemFont(ofSize: 30, weight: .bold)
        return label
    }()
    
    private let vStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 10
        return stackView
    }()
    
    private let hStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fill
        return stackView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureLayout() {
        contentView.addSubview(hStackView)
        hStackView.addArrangedSubview(vStackView)
        hStackView.addArrangedSubview(valueLabel)
        
        vStackView.addArrangedSubview(dateLabel)
        vStackView.addArrangedSubview(keyLabel)

        let inset: CGFloat = 20
        NSLayoutConstraint.activate([
            hStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: inset),
            hStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: inset),
            hStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -inset),
            hStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -inset)
        ])
    }
}
