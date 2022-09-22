//
//  CustomTableViewCell.swift
//  GyroData
//
//  Created by 1 on 2022/09/21.
//

import UIKit


class CustomCell: UITableViewCell {
    
    static let identifier = "cell"
    
    var leftLabel: UILabel = {
        let leftLabel = UILabel()
        leftLabel.translatesAutoresizingMaskIntoConstraints = false
        return leftLabel
    }()
    let rightLabel : UILabel = {
        let rightLabel = UILabel()
        rightLabel.translatesAutoresizingMaskIntoConstraints = false
        return rightLabel
    }()
    let centerLabel :UILabel =  {
        let centerLabel = UILabel()
        centerLabel.translatesAutoresizingMaskIntoConstraints = false
        return centerLabel
    }()
   
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func addContentView() {
        self.addSubview(leftLabel)
        self.addSubview(rightLabel)
        self.addSubview(centerLabel)
    }
    func layout() {
        let margin: CGFloat = 10
        NSLayoutConstraint.activate([
            leftLabel.topAnchor.constraint(equalTo: self.topAnchor),
            leftLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            leftLabel.widthAnchor.constraint(equalToConstant: 20),
            leftLabel.heightAnchor.constraint(equalToConstant: 20),
            
            rightLabel.topAnchor.constraint(equalTo: self.topAnchor),
            rightLabel.leadingAnchor.constraint(equalTo: leftLabel.trailingAnchor, constant: margin),
            rightLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            
            centerLabel.topAnchor.constraint(equalTo: self.topAnchor),
            centerLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            centerLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            centerLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: margin),
        ])
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(leftLabel)
        contentView.addSubview(rightLabel)
        contentView.addSubview(centerLabel)
        
        leftLabel.leftAnchor.constraint(equalTo: safeAreaLayoutGuide.leftAnchor, constant: 10).isActive = true
        rightLabel.rightAnchor.constraint(equalTo: safeAreaLayoutGuide.rightAnchor, constant: -10).isActive = true
    }
    required init?(coder: NSCoder) {
        fatalError()
        
    }
}

extension CustomCell {
    public func bind(model: TestCell) {
        leftLabel.text = model.liftName
        rightLabel.text = model.rightName
        centerLabel.text = model.centers
    }
}

