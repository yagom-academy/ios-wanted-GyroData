//
//  MeasureDataCell.swift
//  GyroData
//
//  Created by Kyo, JPush on 2023/02/01.
//

import UIKit

final class MeasureDataCell: UITableViewCell {
    private enum Constant {
        static let spacingValue = 10.0
        static let sideValue = 40.0
    }
    private let dateLabel = UILabel(textStyle: .body)
    private let sensorLabel = UILabel(textStyle: .title1)
    private let runTimeLabel = UILabel(textStyle: .largeTitle)
    
    private lazy var labelStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [dateLabel, sensorLabel])
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .fillEqually
        stackView.spacing = Constant.spacingValue
        return stackView
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [labelStackView, runTimeLabel])
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fillProportionally
        stackView.spacing = Constant.spacingValue
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
        setupConstraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupData(data: MeasureData) {
        guard let type = data.type else { return }
        
        dateLabel.text = data.date.description
        sensorLabel.text = "\(type)"
        runTimeLabel.text = String(data.runTime)
    }
}

extension MeasureDataCell {
    private func setupView() {
        contentView.addSubview(stackView)
    }
    
    private func setupConstraint() {
        let safeArea = contentView.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(
                equalTo: safeArea.topAnchor,
                constant: Constant.spacingValue
            ),
            stackView.leadingAnchor.constraint(
                equalTo: safeArea.leadingAnchor,
                constant: Constant.sideValue
            ),
            stackView.trailingAnchor.constraint(
                equalTo: safeArea.trailingAnchor,
                constant: -Constant.sideValue
            ),
            stackView.bottomAnchor.constraint(
                equalTo: safeArea.bottomAnchor,
                constant: -Constant.spacingValue
            ),
        ])
    }
}

extension MeasureDataCell: Identifiable { }
