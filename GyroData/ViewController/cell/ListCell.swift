//
//  CustomCell.swift
//  GyroData
//
//  Created by 천승희 on 2022/12/27.
//

import UIKit

class ListCell: UITableViewCell {
    static let cellId = "CellId"
    
    let timeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 13)
        
        return label
    }()
    
    let typeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 25)
        
        return label
    }()
    
    lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [timeLabel, typeLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 10
        
        return stackView
    }()
    
    let valueLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 40)
        
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    func layout() {
        self.addSubview(stackView)
        self.addSubview(valueLabel)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10).isActive = true
        stackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true
        stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10).isActive = true
        
        valueLabel.translatesAutoresizingMaskIntoConstraints = false
        valueLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -30).isActive = true
        valueLabel.centerYAnchor.constraint(equalTo: stackView.centerYAnchor).isActive = true
    }
}
