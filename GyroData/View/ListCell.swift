//
//  ListCell.swift
//  GyroData
//
//  Created by stone, LJ on 2023/01/31.
//

import UIKit

class ListCell: UITableViewCell {
    static let identifier = ListCell.description()
    
    var viewModel: ListCellViewModel?
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .caption1)
        return label
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .title1)
        return label
    }()
    
    let secondLabel: UILabel = {
        let label = UILabel()
        label.font = label.font.withSize(50)
        label.textAlignment = .right
        return label
    }()
    
    let labelStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        return stackView
    }()
    
    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureData(viewModel: ListCellViewModel) {
        self.viewModel = viewModel
        configureBind()
        viewModel.load()
    }
    
    func configureBind() {
        viewModel?.bind(handler: { entity in
            self.titleLabel.text = entity.measureType
            self.dateLabel.text =  entity.date?.formatted("yyyy/MM/dd HH:mm:ss")
            self.secondLabel.text = "\(entity.time)"
        })
    }
    
    func configureLayout() {
        addSubview(stackView)
        stackView.addArrangedSubview(labelStackView)
        stackView.addArrangedSubview(secondLabel)
        labelStackView.addArrangedSubview(dateLabel)
        labelStackView.addArrangedSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: 15),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor,constant: -15),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -30),
        ])
    }
}
