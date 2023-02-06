//
//  MotionListCell.swift
//  GyroData
//
//  Created by Aaron, Gundy on 2023/01/31.
//

import UIKit

class MotionListCell: UICollectionViewListCell, Reusable {

    let dateLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .caption2)

        return label
    }()

    let timeLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .largeTitle)

        return label
    }()

    let typeLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .title3)

        return label
    }()

    lazy var innerStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [dateLabel, typeLabel])
        stackView.axis = .vertical
        stackView.spacing = 20

        return stackView
    }()

    lazy var containerStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [innerStackView, timeLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fillProportionally
        stackView.alignment = .center
//        stackView.spacing = 8
        stackView.axis = .horizontal

        return stackView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureHierarchy()
        configureLayout()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 4, left: 32, bottom: 4, right: 16))
    }

    func configureHierarchy() {
        contentView.addSubview(containerStackView)
    }

    func configureLayout() {
        NSLayoutConstraint.activate([
            containerStackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            containerStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            containerStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            containerStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            containerStackView.heightAnchor.constraint(equalTo: innerStackView.heightAnchor, multiplier: 2)
        ])
    }
}


