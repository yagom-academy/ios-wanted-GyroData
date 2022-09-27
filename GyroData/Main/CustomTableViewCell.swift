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
//        let stackView = UIStackView(arrangedSubviews: [title,second,measureDate])
//        contentView.addSubview(stackView)
//        stackView.snp.makeConstraints { (make) in
//            make.left.bottom.right.top.equalTo(contentView)
//        }
//
//        return stackView
//    }()
    
    lazy var title: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20)
        return label
    }()
    
    lazy var second: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 40)
        return label
    }()
    
    lazy var measureDate: UILabel = {
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
        contentView.addSubview(title)
        contentView.addSubview(second)
        contentView.addSubview(measureDate)
        
        measureDate.snp.makeConstraints { (make) in
            make.leading.equalTo(contentView.snp.leading).offset(20)
            make.top.equalTo(contentView.snp.top).offset(10)
            make.bottom.equalTo(title.snp.top).offset(-10)
        }
        title.snp.makeConstraints { make in
            make.bottom.equalTo(contentView.snp.bottom)
            make.leading.equalTo(contentView.snp.leading).offset(20)
            //            make.top.equalTo(dateLabel.snp.bottom).offset(3)
            //            make.bottom.equalTo(stackView.snp.bottom)
        }
        second.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.top).offset(10)
            make.trailing.equalTo(contentView.snp.trailing).offset(-5)
        }
    }
}

extension CustomTableViewCell {
    public func bind1(model: GyroModel) {
        measureDate.text = model.measureDate
        second.text = "\(model.second)"
        title.text = model.title
    }
}

