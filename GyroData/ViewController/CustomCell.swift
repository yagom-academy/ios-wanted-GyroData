//
//  CustomTableViewCell.swift
//  GyroData
//
//  Created by 1 on 2022/09/21.
//

import UIKit


class CustomCell: UITableViewCell {
    
    static let identifier = "CustomCell"
    
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
  
//    var notice: RunDataList? {
//        didSet {
//
//        }
//    }
    
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
            
            
      
        centerLabel.topAnchor.constraint(equalTo: self.topAnchor),
        centerLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor),
        centerLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
        centerLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: margin),
        ])
    }
   
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    required init?(coder: NSCoder) {
        fatalError()
    }
    //    var subLabel: UILabel = {
    //        let subTitleLabel = UILabel()
    //        subTitleLabel.text = "mm"
    //        subTitleLabel.translatesAutoresizingMaskIntoConstraints = false
    //        return subTitleLabel
    //    }()
    
}
extension CustomCell {
    public func bind(model: TestCell) {
        leftLabel.text = model.liftName
        rightLabel.text = model.rightName
        centerLabel.text = model.centers
    }
}

