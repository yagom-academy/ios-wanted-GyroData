//
//  CustomTableViewCell.swift
//  GyroData
//
//  Created by so on 2022/09/22.
//

import UIKit
import SnapKit

class CustomTableViewCell: UITableViewCell {
    
    static let identifier = "CustomTableViewCell"
    
    lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [dataTypeLabel,valueLabel,dateLabel])
        contentView.addSubview(stackView)
        stackView.snp.makeConstraints { (make) in
            make.left.bottom.right.top.equalTo(contentView)
        }
        
        return stackView
    }()
    
    lazy var dataTypeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20)
        return label
    }()
    
    lazy var valueLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 40)
        return label
    }()
    
    lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addContentView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been impl")
    }
    private func addContentView() {
        stackView.addSubview(dataTypeLabel)
        stackView.addSubview(valueLabel)
        stackView.addSubview(dateLabel)
        
        dateLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(stackView.snp.leading).offset(10)
            make.top.equalTo(stackView.snp.top).offset(10)
            make.bottom.equalTo(dataTypeLabel.snp.top).offset(-10)
        }
        dataTypeLabel.snp.makeConstraints { make in
            make.bottom.equalTo(stackView.snp.bottom)
            make.leading.equalTo(dateLabel)
//            make.top.equalTo(dateLabel.snp.bottom).offset(3)
//            make.bottom.equalTo(stackView.snp.bottom)
        }
        valueLabel.snp.makeConstraints { make in
//            make.top.equalTo(stackView.snp.top).offset(10)
            make.trailing.equalTo(stackView.snp.trailing).offset(1)
        }
    }
}

extension CustomTableViewCell {
    public func bind(model: CustomCellModel) {
        dataTypeLabel.text = model.dataTypeLabel
        valueLabel.text = model.valueLabel
        dateLabel.text = model.dateLabel
    }
}

