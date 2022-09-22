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
    
//    lazy var stackView: UIStackView = {
//        let stackView = UIStackView(arrangedSubviews: [dataTypeLabel,valueLabel])
//        contentView.addSubview(stackView)
//
//        let secondStackView = UIStackView(arrangedSubviews: [dateLabel])
//        contentView.addSubview(secondStackView)
//
//        stackView.snp.makeConstraints { (make) in
//            make.left.bottom.right.equalTo(contentView)
//            make.top.equalTo(secondStackView).offset(25)
//        }
//        secondStackView.snp.makeConstraints { (make) in
//            make.top.equalTo(contentView).offset(6)
//        }
//        return stackView
//    }()
    
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
        contentView.addSubview(dataTypeLabel)
        contentView.addSubview(valueLabel)
        contentView.addSubview(dateLabel)
        
        dateLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(contentView).offset(20)
            make.top.equalTo(contentView)
        }
        dataTypeLabel.snp.makeConstraints { make in
            make.leading.equalTo(contentView).offset(20)
            make.top.equalTo(dateLabel.snp.bottom)
            make.bottom.equalTo(contentView).offset(-5)
        }
        valueLabel.snp.makeConstraints { make in
            make.top.bottom.equalTo(contentView)
            make.trailing.equalTo(contentView).offset(-50)
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

