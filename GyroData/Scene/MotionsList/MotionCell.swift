//
//  MotionCell.swift
//  GyroData
//
//  Created by Wonbi on 2023/02/03.
//

import UIKit

protocol CellIdentifiable {
    static var reuseIdentifier: String { get }
}

extension CellIdentifiable {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}

final class MotionCell: UITableViewCell, CellIdentifiable {
    enum Constant {
        static let padding: Double = 16.0
        static let halfPadding: Double = 8.0
    }
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .body)
        return label
    }()
    
    private let measurementTypeLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .title1)
        return label
    }()
    
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .largeTitle)
        return label
    }()
    
    private let contentsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .fill
        stackView.spacing = Constant.padding
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = Constant.padding
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureSubviews()
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureSubviews() {
        [dateLabel, measurementTypeLabel].forEach { contentsStackView.addArrangedSubview($0) }
        [contentsStackView, timeLabel].forEach { mainStackView.addArrangedSubview($0) }
        
        contentView.addSubview(mainStackView)
    }
    
    private func configureLayout() {
        let safeArea = contentView.safeAreaLayoutGuide
        
        let mainStackViewBottomAnchor = mainStackView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor,
                                                           constant: -Constant.halfPadding)
        mainStackViewBottomAnchor.priority = .defaultHigh
        
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: safeArea.topAnchor,
                                               constant: Constant.halfPadding),
            mainStackView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor,
                                                   constant: Constant.padding),
            mainStackView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor,
                                                    constant: -Constant.padding),
            mainStackViewBottomAnchor
        ])
    }
    
    func setUpCellData(date: String, measurementType: String, time: String) {
        dateLabel.text = date
        measurementTypeLabel.text = measurementType
        timeLabel.text = time
    }
}
