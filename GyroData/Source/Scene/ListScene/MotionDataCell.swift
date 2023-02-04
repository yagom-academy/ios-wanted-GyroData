//
//  MotionDataCell.swift
//  GyroData
//
//  Created by inho on 2023/02/03.
//

import UIKit

final class MotionDataCell: UITableViewCell {
    static let identifier = String(describing: MotionDataCell.self)
    
    private let totalStackView: UIStackView = {
        let stackView = UIStackView()
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fillEqually
        stackView.alignment = .center
        stackView.axis = .horizontal
        stackView.spacing = 30
        
        return stackView
    }()
    private let leftStackView: UIStackView = {
        let stackView = UIStackView()
        
        stackView.axis = .vertical
        stackView.spacing = 20
        
        return stackView
    }()
    private let measuredDateLabel: UILabel = {
        let label = UILabel()
        
        label.setContentHuggingPriority(.defaultHigh, for: .vertical)
        label.font = .preferredFont(forTextStyle: .caption1)
        
        return label
    }()
    private let typeLabel: UILabel = {
        let label = UILabel()
        
        label.font = .preferredFont(forTextStyle: .title2)
        
        return label
    }()
    private let durationLabel: UILabel = {
        let label = UILabel()
        
        label.font = .preferredFont(forTextStyle: .largeTitle)
        label.textAlignment = .center
        
        return label
    }()
    var viewModel: MotionCellViewModel?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureStackView()
        configureContentView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureStackView() {
        [measuredDateLabel, typeLabel].forEach {
            leftStackView.addArrangedSubview($0)
        }
    }
    
    private func configureContentView() {
        [leftStackView, durationLabel].forEach {
            totalStackView.addArrangedSubview($0)
        }
        contentView.addSubview(totalStackView)

        leftStackView.layoutMargins = .init(top: 20, left: 30, bottom: 20, right: 0)
        leftStackView.isLayoutMarginsRelativeArrangement = true
        
        NSLayoutConstraint.activate([
            totalStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            totalStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            totalStackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            totalStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    func configureViewModel(_ viewModel: MotionCellViewModel) {
        self.viewModel = viewModel
        bindViewModel()
    }
    
    func bindViewModel() {
        viewModel?.bindDate { [weak self] dateString in
            self?.measuredDateLabel.text = dateString
        }
        viewModel?.bindType { [weak self] type in
            self?.typeLabel.text = type
        }
        viewModel?.bindDuration { [weak self] duration in
            self?.durationLabel.text = duration
        }
    }
}
