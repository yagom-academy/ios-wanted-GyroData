//
//  TableViewCell.swift
//  GyroExample
//
//  Created by KangMingyo on 2022/09/24.
//

import UIKit

class TableViewCell: UITableViewCell {
  
    var dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()
    var timeLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 40)
        return label
    }()
    var nameLabel :UILabel =  {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20)
        return label
    }() //스택뷰 설정
    lazy var stackView: UIStackView = {
        var stackView = UIStackView(arrangedSubviews: [dateLabel, nameLabel])
        stackView.axis = .vertical
        stackView.spacing = 20
        return stackView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(timeLabel)
        addSubview(stackView)
        configure()
    }
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    /// 레이아웃 설정
    func configure() {
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        timeLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        timeLabel.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -40).isActive = true
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        stackView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 20).isActive = true
    }
}
