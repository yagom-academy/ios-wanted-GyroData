//
//  GyroDataTableViewCell.swift
//  GyroData
//
//  Created by 리지 on 2023/06/12.
//

import UIKit

final class GyroDataTableViewCell: UITableViewCell {
    static let identifier = "GyroDataTableViewCell"
    private let horizontalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        
        return stackView
    }()
    
    private let verticalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        
        return stackView
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
       
        return label
    }()
    
    private let sensorTypeLabel: UILabel = {
        let label = UILabel()

        return label
    }()
    
    private let recordLabel: UILabel = {
        let label = UILabel()
    
        return label
    }()

    override func awakeFromNib() {
        super.awakeFromNib()
        setUpUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    private func setUpUI() {
        self.backgroundColor = .red
        self.addSubview(horizontalStackView)
        setUpStackView()
    }
    
    private func setUpStackView() {
        horizontalStackView.addArrangedSubview(verticalStackView)
        horizontalStackView.addArrangedSubview(recordLabel)
        
        verticalStackView.addArrangedSubview(dateLabel)
        verticalStackView.addArrangedSubview(sensorTypeLabel)
        
        horizontalStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            horizontalStackView.topAnchor.constraint(equalTo: self.topAnchor),
            horizontalStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            horizontalStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            horizontalStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
    }
}
