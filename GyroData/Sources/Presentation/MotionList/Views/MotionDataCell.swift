//
//  MotionDataCell.swift
//  GyroData
//
//  Created by Ari on 2022/12/27.
//

import UIKit

class MotionDataCell: UITableViewCell {
    
    private lazy var backgroundStackView: UIStackView = {
        let stackView = UIStackView(axis: .horizontal, alignment: .center, distribution: .fill, spacing: 2)
        stackView.backgroundColor = .clear
        stackView.addArrangedSubviews(labelStackView, measurementTimeLabel)
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 4, leading: 20, bottom: 4, trailing: 20)
        return stackView
    }()
    
    private lazy var labelStackView: UIStackView = {
        let stackView = UIStackView(axis: .vertical, alignment: .leading, distribution: .fill, spacing: 8)
        stackView.backgroundColor = .clear
        stackView.addArrangedSubviews(dateLabel, titleLabel)
        return stackView
    }()
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.text = "2022/09/08 14:50:43"
        label.font = .preferredFont(for: .footnote, weight: .semibold)
        label.textColor = .label
        return label
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Accelerometer"
        label.font = .preferredFont(for: .title1, weight: .semibold)
        label.textColor = .label
        return label
    }()
    
    private lazy var measurementTimeLabel: UILabel = {
        let label = UILabel()
        label.text = "43.4"
        label.font = .preferredFont(for: .largeTitle, weight: .bold)
        label.textColor = .label
        return label
    }()

    override func prepareForReuse() {
        super.prepareForReuse()
        reset()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func configure() {
        selectionStyle = .none
        contentView.addSubviews(backgroundStackView)
        NSLayoutConstraint.activate([
            backgroundStackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            backgroundStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            backgroundStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            backgroundStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    private func reset() {
        dateLabel.text = nil
        titleLabel.text = nil
        measurementTimeLabel.text = nil
    }

}

extension MotionDataCell {
    
    func setUp(by motionEntity: MotionEntity?) {
        dateLabel.text = motionEntity?.date?.formatted(for: .display)
        titleLabel.text = motionEntity?.type
        measurementTimeLabel.text = String(format: "%.1f", motionEntity?.duration ?? 0)
    }
    
}
