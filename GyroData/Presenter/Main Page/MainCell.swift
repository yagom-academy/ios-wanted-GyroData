//
//  MainCell.swift
//  GyroData
//
//  Created by Tak on 2022/12/28.
//

import UIKit

class MainCell: UITableViewCell {
    
    static let cellID = "MainCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    let sensorTypeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .title1)
        label.textColor = .black
        return label
    }()
    let recordedDateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .caption1)
        label.textColor = .black
        return label
    }()
    let valueLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .largeTitle)
        label.textColor = .black
        return label
    }()
    private let recordedStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 25
        stackView.distribution = .equalSpacing
        return stackView
    }()
    
    func configureCell(gyroItem: GyroItem) {
        sensorTypeLabel.text = gyroItem.sensorType
        recordedDateLabel.text = gyroItem.date
        valueLabel.text = gyroItem.figure
    }
    
    private func setLayout() {
        self.contentView.addSubview(recordedStackView)
        recordedStackView.addArrangedSubview(recordedDateLabel)
        recordedStackView.addArrangedSubview(sensorTypeLabel)
        self.contentView.addSubview(valueLabel)
        setStackViewConstraints()
        setValueLabelConstraints()
    }
    
    private func setStackViewConstraints() {
        NSLayoutConstraint.activate([
            recordedStackView.topAnchor.constraint(equalTo: self.topAnchor),
            recordedStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 30),
            recordedStackView.trailingAnchor.constraint(equalTo: valueLabel.leadingAnchor),
            recordedStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
    
    private func setValueLabelConstraints() {
        NSLayoutConstraint.activate([
            valueLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            valueLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -30)
        ])
    }
}
