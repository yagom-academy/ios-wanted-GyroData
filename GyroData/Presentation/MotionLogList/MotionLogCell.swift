//
//  MotionLogCell.swift
//  GyroData
//
//  Copyright (c) 2023 Jeremy All rights reserved.


import UIKit

final class MotionLogCell: UICollectionViewCell {
    
    static let identifier = "motion"
    
    // MARK: View(s)
    
    private let createdAtLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        return label
    }()
    private let motionTypeLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        return label
    }()
    private let runTimeLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        return label
    }()
    
    private let dateAndNameVerticalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        return stackView
    }()
    private let contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    // MARK: Override(s)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        combineViews()
        configureViewsConstraints()
        backgroundColor = .systemGreen
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        createdAtLabel.text = nil
        motionTypeLabel.text = nil
        runTimeLabel.text = nil
    }
    
    // MARK: Function(s)
    
    private func combineViews() {
        let dateAndNameViews: [UIView] = [
            createdAtLabel,
            motionTypeLabel
        ]
        let contentViews: [UIView] = [
            dateAndNameVerticalStackView,
            runTimeLabel
        ]
        dateAndNameVerticalStackView.addMultipleArrangedSubviews(views: dateAndNameViews)
        contentStackView.addMultipleArrangedSubviews(views: contentViews)
        contentView.addSubview(contentStackView)
    }
    
    private func configureViewsConstraints() {
        NSLayoutConstraint.activate([
            contentStackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            contentStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            contentStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            contentStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
}
