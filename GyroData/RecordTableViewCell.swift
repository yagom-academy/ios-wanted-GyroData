//
//  RecordTableViewCell.swift
//  GyroData
//
//  Created by 천수현 on 2022/12/27.
//

import UIKit

final class RecordTableViewCell: UITableViewCell {
    static let reuseIdentifier = "recordTableViewCell"

    private let dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let motionModeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .largeTitle)
        return label
    }()

    private let measureTimeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .largeTitle)
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        layout()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        fatalError("init(coder:) has not been implemented")
    }

    func setUpContents(motionRecord: MotionRecord) {
        dateLabel.text = motionRecord.startDate.toString()
        motionModeLabel.text = motionRecord.motionMode.name
        measureTimeLabel.text = Double(motionRecord.coordinates.count / 10).description
    }

    private func layout() {
        [dateLabel, motionModeLabel, measureTimeLabel].forEach {
            self.contentView.addSubview($0)
        }

        NSLayoutConstraint.activate([
            dateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            dateLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            motionModeLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            motionModeLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 20),
            motionModeLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
            measureTimeLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            measureTimeLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])

        measureTimeLabel.setContentHuggingPriority(.required, for: .horizontal)
    }
}

fileprivate extension Date {
    func toString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
        return dateFormatter.string(from: self)
    }
}

fileprivate extension MotionMode {
    var name: String {
        switch self {
        case .accelerometer:
            return "Accelerometer"
        case .gyroscope:
            return "Gyro"
        }
    }
}
