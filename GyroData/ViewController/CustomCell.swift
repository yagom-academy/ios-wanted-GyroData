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
        leftLabel.text = "2022/09/20 20:20:20"
        leftLabel.translatesAutoresizingMaskIntoConstraints = false
        return leftLabel
    }()
    var rightLabel : UILabel = {
        let rightLabel = UILabel()
        rightLabel.translatesAutoresizingMaskIntoConstraints = false
        return rightLabel
    }()
    var centerLabel :UILabel =  {
        let centerLabel = UILabel()
        centerLabel.translatesAutoresizingMaskIntoConstraints = false
        return centerLabel
    }()
  lazy  var stackView: UIStackView = {
        var stackView = UIStackView(arrangedSubviews: [leftLabel, centerLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical //방향 버티컬 호리즌탈
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 20
        return stackView
    }()
    
    func setModel(model: RunDataList) {
        leftLabel.text = model.timestamp
        centerLabel.text = model.type
        rightLabel.text = "\(model.interval)"
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(leftLabel)
        contentView.addSubview(rightLabel)
        contentView.addSubview(centerLabel)
        contentView.addSubview(stackView)
        
        rightLabel.rightAnchor.constraint(equalTo: safeAreaLayoutGuide.rightAnchor, constant: -50).isActive = true
        rightLabel.font = .italicSystemFont(ofSize: 30)
        rightLabel.font = UIFont.preferredFont(forTextStyle: .title1)
        leftLabel.leftAnchor.constraint(equalTo: safeAreaLayoutGuide.leftAnchor, constant: 10).isActive = true
        leftLabel.font = .italicSystemFont(ofSize: 12)
        leftLabel.numberOfLines = 0
        leftLabel.font = UIFont.preferredFont(forTextStyle: .title3)
        centerLabel.leftAnchor.constraint(equalTo: safeAreaLayoutGuide.leftAnchor, constant: 10).isActive = true
        centerLabel.font = .italicSystemFont(ofSize: 22)
        centerLabel.numberOfLines = 0
        centerLabel.font = UIFont.preferredFont(forTextStyle: .title2)
        
        
        
        
    }
    required init?(coder: NSCoder) {
        fatalError()
    }
}
