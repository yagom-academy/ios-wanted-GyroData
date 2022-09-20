//
//  GyroDataListTableViewCell.swift
//  GyroData
//
//  Created by 신동오 on 2022/09/20.
//

import UIKit

class CustomTableViewCell: UITableViewCell {
    static let identifier = "CustomTableViewCell"

    private let dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 10, weight: .regular)
        label.text = "date"
        return label
    }()
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 15, weight: .bold)
        label.text = "name"
        return label
    }()
    private let dataLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 30, weight: .heavy)
        label.text = "data"
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .white
        
        contentView.addSubview(dateLabel)
        contentView.addSubview(nameLabel)
        contentView.addSubview(dataLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        dateLabel.frame = CGRect(x: 10, y: 5, width: 100, height: contentView.frame.size.height-10)
        nameLabel.frame = CGRect(x: 10, y: 5, width: 100, height: contentView.frame.size.height-10)
        dataLabel.frame = CGRect(x: 250, y: 5, width: 100, height: contentView.frame.size.height-10)
    }

}
