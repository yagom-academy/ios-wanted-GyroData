//
//  FirstTableViewCell.swift
//  GyroData
//
//  Created by dhoney96 on 2022/12/27.
//

import UIKit

class FirstTableViewCell: UITableViewCell {
    
    private enum Constant: CGFloat {
        case stackViewInset = 10.0
        case spacing = 50.0
    }
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .equalSpacing
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let typeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .title2)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .title1)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureStackView()
        configureLayout()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func configureStackView() {
        self.contentView.addSubview(stackView)
        self.contentView.addSubview(timeLabel)
        self.stackView.addArrangedSubview(dateLabel)
        self.stackView.addArrangedSubview(typeLabel)
    }
    
    private func configureLayout() {
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: Constant.stackViewInset.rawValue),
            stackView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: Constant.spacing.rawValue),
            stackView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -Constant.stackViewInset.rawValue)
        ])
        
        NSLayoutConstraint.activate([
            timeLabel.leadingAnchor.constraint(equalTo: self.stackView.trailingAnchor, constant: Constant.spacing.rawValue),
            timeLabel.centerYAnchor.constraint(equalTo: self.stackView.centerYAnchor)
        ])
    }
    
    func setText(date: String, type: String, time: String) {
        self.dateLabel.text = date
        self.typeLabel.text = type
        self.timeLabel.text = time
    }
}
