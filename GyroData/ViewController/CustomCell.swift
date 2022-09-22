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
        stackView.spacing = 10
        return stackView
    }()
    
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
        
        rightLabel.rightAnchor.constraint(equalTo: safeAreaLayoutGuide.rightAnchor, constant: -10).isActive = true
        leftLabel.leftAnchor.constraint(equalTo: safeAreaLayoutGuide.leftAnchor, constant: 5).isActive = true
        centerLabel.leftAnchor.constraint(equalTo: safeAreaLayoutGuide.leftAnchor, constant: 10).isActive = true
        
        
    }
    required init?(coder: NSCoder) {
        fatalError()
    }
}
//
//extension CustomCell {
//    public func bind(model: TestCell) {
//        leftLabel.text = model.liftName
//        rightLabel.text = model.rightName
//        centerLabel.text = model.centers
//    }
//}
//
