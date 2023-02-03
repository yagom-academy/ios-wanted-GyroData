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

class MotionCell: UITableViewCell, CellIdentifiable {
    enum Constant {
        static let spacePadding: Double = 16.0
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
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let contentsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .fill
        stackView.spacing = Constant.spacePadding
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private func configureView() {
        [contentsStackView, timeLabel].forEach {
            addSubview($0)
        }
    }
    
    private func configureLayout() {
        NSLayoutConstraint.activate([
            contentsStackView.topAnchor.constraint(equalTo: self.topAnchor,
                                                   constant: Constant.spacePadding),
            contentsStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor,
                                                       constant: Constant.spacePadding),
            contentsStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            
            timeLabel.leadingAnchor.constraint(equalTo: contentsStackView.trailingAnchor,
                                               constant: Constant.spacePadding),
            timeLabel.centerYAnchor.constraint(equalTo: contentsStackView.centerYAnchor)
        ])
    }
    
    func setUpCellData(date: String, measurementType: String, time: String) {
        dateLabel.text = date
        measurementTypeLabel.text = measurementType
        timeLabel.text = time
    }
}
