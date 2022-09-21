//
//  GyroDataListTableViewCell.swift
//  GyroData
//
//  Created by 신동오 on 2022/09/20.
//

import UIKit

class GyroDataListTableViewCell: UITableViewCell {
    static let identifier = "GyroDataListTableViewCell"
    
    private let leftStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .fill
        stackView.spacing = 10
        return stackView
    }()

    let dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.text = "2022/09/08 14:50:43"
        return label
    }()
    
    let dataTypeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.text = "Accelerometer"
        return label
    }()
    
    let timeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 30, weight: .heavy)
        label.text = "43.4"
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .white
        setLayouts()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setLayouts() {
        setViewHierarchy()
        setConstraints()
    }
    
    private func setViewHierarchy() {
        contentView.addSubview(leftStackView)
        contentView.addSubview(timeLabel)
        leftStackView.addArrangedSubview(dateLabel)
        leftStackView.addArrangedSubview(dataTypeLabel)
    }
    
    private func setConstraints() {
        [leftStackView, timeLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        leftStackView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        leftStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20).isActive = true
        
        timeLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        timeLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20).isActive = true
    }

}
